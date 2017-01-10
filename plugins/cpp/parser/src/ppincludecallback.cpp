#include <boost/log/trivial.hpp>

#include <parser/sourcemanager.h>
#include <util/odbtransaction.h>

#include "filelocutil.h"
#include "ppincludecallback.h"

namespace cc
{
namespace parser
{

PPIncludeCallback::PPIncludeCallback(
  ParserContext& ctx_,
  clang::ASTContext& astContext_,
  std::unordered_map<model::CppAstNodeId, std::uint64_t>& mangledNameCache_,
  clang::Preprocessor& pp_):
  _ctx(ctx_),
  _pp(pp_),
  _cppSourceType("CPP"),
  _clangSrcMgr(astContext_.getSourceManager()),
  _fileLocUtil(astContext_.getSourceManager()),
  _mangledNameCache(mangledNameCache_)
{
}

PPIncludeCallback::~PPIncludeCallback()
{
  _ctx.srcMgr.persistFiles();

  (util::OdbTransaction(_ctx.db))([this]{
    persistAll(_astNodes);
    persistAll(_headerIncs);
  });
}

model::CppAstNodePtr PPIncludeCallback::createFileAstNode(
  const model::FilePtr& file_,
  const clang::SourceRange& srcRange_)
{
  model::CppAstNodePtr astNode(new model::CppAstNode());

  astNode->astValue = file_->path;
  astNode->mangledName = std::to_string(file_->id);
  astNode->mangledNameHash = util::fnvHash(astNode->mangledName);
  astNode->symbolType = model::CppAstNode::SymbolType::File;
  astNode->astType = model::CppAstNode::AstType::Usage;

  model::FileLoc fileLoc;
  _fileLocUtil.setRange(srcRange_.getBegin(), srcRange_.getEnd(), fileLoc.range);
  fileLoc.file = _ctx.srcMgr.getFile(
    _fileLocUtil.getFilePath(srcRange_.getBegin()));

  const std::string& type = fileLoc.file.load()->type;
  if (type != model::File::DIRECTORY_TYPE && type != _cppSourceType)
  {
    fileLoc.file->type = _cppSourceType;
    _ctx.srcMgr.updateFile(*fileLoc.file);
  }

  astNode->location = fileLoc;
  astNode->id = model::createIdentifier(*astNode);

  return astNode;
}

void PPIncludeCallback::InclusionDirective(
  clang::SourceLocation hashLoc,
  const clang::Token&,
  clang::StringRef FileName,
  bool,
  clang::CharSourceRange FilenameRange,
  const clang::FileEntry *,
  clang::StringRef SearchPath,
  clang::StringRef,
  const clang::Module *)
{
  if (SearchPath.empty())
    return;

  clang::SourceManager& srcMgr = _pp.getSourceManager();
  clang::SourceLocation expLoc = srcMgr.getExpansionLoc(hashLoc);
  clang::PresumedLoc presLoc = srcMgr.getPresumedLoc(expLoc);

  std::string includedPath = SearchPath.str() + '/' + FileName.str();
  model::FilePtr included = _ctx.srcMgr.getFile(includedPath);
  included->type = _cppSourceType;

  std::string includerPath = presLoc.getFilename();
  model::FilePtr includer = _ctx.srcMgr.getFile(includerPath);
  included->type = _cppSourceType;

  //--- CppAstNode ---//

  auto fileNode = createFileAstNode(included, FilenameRange.getAsRange());
  if (insertToCache(fileNode))
    _astNodes.push_back(fileNode);

  model::CppHeaderInclusionPtr inclusion(new model::CppHeaderInclusion);
  inclusion->includer = includer;
  inclusion->included = included;

  _headerIncs.push_back(inclusion);
}

bool PPIncludeCallback::insertToCache(const model::CppAstNodePtr node_)
{
  static std::mutex cacheMutex;
  std::lock_guard<std::mutex> guard(cacheMutex);

  return _mangledNameCache.insert(
    std::make_pair(node_->id, node_->mangledNameHash)).second;
}

} // parser
} // cc
