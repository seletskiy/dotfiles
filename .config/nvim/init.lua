local colors = require("colors")
local cfg = require("cfg")

-- TODO: is it possible to set via packer.nvim?
local config_path = vim.fn.stdpath("config") .. "/init.lua"
local config_path_packages = vim.fn.stdpath("config") .. "/?.lua"

if not string.find(package.path, ";" .. config_path_packages) then
	package.path = package.path .. ";" .. config_path_packages
end

function ReloadConfig()
	require("plenary.reload").reload_module("cfg")
	require("plenary.reload").reload_module("colors")
	require("plenary.reload").reload_module("init")
	require("plenary.reload").reload_module("plugins")
	require("plenary.reload").reload_module("snippets")
	require("plugins")
	vim.cmd([[ source ]] .. config_path .. [[ | PackerCompile ]])
	require("init")
end

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	group = vim.api.nvim_create_augroup("reload_config", { clear = true }),
	pattern = { "init.lua", "plugins.lua", "colors.lua" },
	callback = ReloadConfig,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	group = vim.api.nvim_create_augroup("highligh_yank", { clear = true }),
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank({ higroup = "Search", timeout = 150 })
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = vim.api.nvim_create_augroup("dir_autocreate", { clear = true }),
	pattern = { "*" },
	callback = function()
		-- TODO: rework to pure lua
		vim.cmd([[ if !isdirectory(expand('%:h')) | call mkdir(expand('%:h'),'p') | endif ]])
	end,
})

vim.o.termguicolors = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.number = true
vim.o.signcolumn = "yes:1"
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.shortmess = "sAIct"
vim.o.gdefault = true
vim.o.undofile = true
vim.o.undodir = vim.fn.expand("$HOME/.local/share/nvim/undo")
vim.o.backupdir = vim.fn.expand("$HOME/.local/share/nvim/backup")
vim.o.list = true
vim.o.listchars = "trail:·,tab:  "
vim.o.winminheight = 0
vim.o.equalalways = false

vim.g.mapleader = " "

vim.keymap.set("n", "<C-Q>", ":q<CR>", { silent = true })
vim.keymap.set("n", "<C-S>", ":w<CR>", { silent = true })
vim.keymap.set("i", "<C-S>", "<C-\\><C-O>:w<CR>", { silent = true })
vim.keymap.set("n", "<Space><Space>", ":nohl<CR>", { silent = true })

vim.keymap.set("n", "<C-PageUp>", "<C-W>k", { silent = true })
vim.keymap.set("n", "<C-PageDown>", "<C-W>j", { silent = true })
vim.keymap.set("n", "<C-Home>", "<C-W>h", { silent = true })
vim.keymap.set("n", "<C-End>", "<C-W>j", { silent = true })
vim.keymap.set("n", "<C-H><C-S>", ":%s/\\v", {})
vim.keymap.set("v", "<C-H>", ":s/\\v", {})
vim.keymap.set("n", "/", "/\\v", { noremap = true })
vim.keymap.set("n", "?", "?\\v", { noremap = true })
-- cnoremap <expr> jk getcmdtype() =~ '^[/?]$' ? '<CR>' : 'jk'
--
local function is_command_search()
	local cmd_type = vim.fn.getcmdtype()
	return cmd_type == "/" or cmd_type == "?" or vim.fn.getcmdline():match("^'.,'.s/")
end

vim.keymap.set("c", "<C-S><C-W>", function()
	return is_command_search() and "<><Left>" or ""
end, { noremap = true, expr = true })

vim.cmd([[
function! g:SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
]])
vim.keymap.set("n", "<leader>z", ":call g:SynStack()<CR>")

vim.keymap.set("n", "<C-G><C-L>", function()
	vim.fn.system("github-link " .. vim.fn.expand("%:p") .. " " .. vim.fn.line("."))
end)

require("rpc")
require("plugins")
require("snippets")

-- TODO: change inline colors with references
-- stylua: ignore start
cfg.hi.set("Special",        { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("SpecialKey",     { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("SpecialChar",    { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("SpecialComment", { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("NonText",        { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Directory",      { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("ErrorMsg",       { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("MoreMsg",        { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("ModeMsg",        { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("LineNr",         { style = "none", fg = colors.variants.gray[04], bg = "none" })
cfg.hi.set("CursorLineNr",   { style = "none", fg = colors.variants.purple[20], bg = "none" })
cfg.hi.set("CursorLine",     { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Question",       { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("StatusLine",     { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("StatusLineNC",   { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("VertSplit",      { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Title",          { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Visual",         { style = "none", fg = colors.white, bg = colors.muted.selection })
cfg.hi.set("WarningMsg",     { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("WildMenu",       { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Folded",         { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("FoldColumn",     { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("DiffAdd",        { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("DiffChange",     { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("DiffDelete",     { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("DiffText",       { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("SignColumn",     { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Conceal",        { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("SpellBad",       { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("SpellCap",       { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("SpellRare",      { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("SpellLocal",     { style = "none", fg = "none",    bg = "none" })

cfg.hi.set("Pmenu",          { style = "none", fg = colors.muted.secondary, bg = colors.variants.gray[02] })
cfg.hi.set("PmenuSel",       { style = "bold", fg = colors.bright.alert, bg = colors.variants.gray[04] })
cfg.hi.set("PmenuSbar",      { style = "none", fg = "none",    bg = colors.variants.gray[02] })
cfg.hi.set("PmenuThumb",     { style = "none", fg = "none",    bg = colors.variants.gray[04] })

cfg.hi.set("NormalFloat",    { style = "none", fg = colors.white,    bg = colors.variants.gray[01] })

cfg.hi.set("CmpItemAbbrDefault", { style = "none", fg = colors.muted.secondary,    bg = "none" })
cfg.hi.set("CmpItemAbbrMatchDefault", { style = "none", fg = colors.bright.secondary,    bg = "none" })

cfg.hi.set("TabLine",        { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("TabLineSel",     { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("TabLineFill",    { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("ColorColumn",    { style = "none", fg = "none",    bg = "#1C1C1C" })
cfg.hi.set("MatchParen",     { style = "none", fg = colors.bright.alert, bg = "none" })
cfg.hi.set("Comment",        { style = "none", fg = colors.variants.gray[07], bg = "none" })
cfg.hi.set("Constant",       { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Identifier",     { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("PreProc",        { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Type",           { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Ignore",         { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Error",          { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Todo",           { style = "bold", fg = "none",    bg = "none" })
cfg.hi.set("String",         { style = "none", fg = colors.variants.gray[10], bg = "none" })
cfg.hi.set("Character",      { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Number",         { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Boolean",        { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Float",          { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Function",       { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Repeat",         { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Label",          { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Operator",       { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Keyword",        { style = "none", fg = colors.variants.purple[18], bg = "none" })
cfg.hi.set("Exception",      { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Define",         { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Macro",          { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("PreCondit",      { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("StorageClass",   { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Structure",      { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Typedef",        { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Tag",            { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Delimiter",      { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Debug",          { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("Normal",         { style = "none", fg = colors.variants.gray[17],    bg = "none" })
cfg.hi.set("Search",         { style = "bold", fg = colors.bright.alert, bg = colors.variants.blue[03] })
cfg.hi.set("IncSearch",      { style = "bold", fg = colors.black, bg = colors.bright.alert })
cfg.hi.set("EndOfBuffer",    { style = "none", fg = colors.variants.gray[06], bg = "none" })
cfg.hi.set("Whitespace",     { style = "none", fg = colors.bright.alert, bg = "none" })

cfg.hi.set("DiagnosticUnderlineError", { style = "none", fg = colors.variants.red[14], bg = colors.variants.red[04] })
cfg.hi.set("DiagnosticUnderlineWarn", { style = "none", fg = "none", bg = colors.variants.yellow[01] })
cfg.hi.set("DiagnosticUnderlineInfo", { style = "none", fg = "none", bg = colors.variants.blue[03] })
cfg.hi.set("DiagnosticUnderlineHint", { style = "none", fg = "none", bg = colors.variants.gray[02] })

--cfg.hi.set("DiagnosticUnderlineError", { style = "none", fg = colors.variants.red[18], bg = colors.variants.red[05] })
cfg.hi.set("DiagnosticError", { style = "none", fg = colors.variants.red[14], bg = "none" })
cfg.hi.set("DiagnosticInfo", { style = "none", fg = colors.variants.gray[05], bg = "none" })
cfg.hi.set("DiagnosticHint", { style = "none", fg = colors.variants.gray[04], bg = "none" })

cfg.hi.set("goDeclaration",  { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("goConditional",  { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("goBuiltins",     { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("goCall",         { style = "none", fg = "none",    bg = "none" })
cfg.hi.set("goErr",          { style = "none", fg = "none",    bg = "none" })

cfg.hi.set("GitSignsAdd",    { style = "none", fg = colors.variants.green[10],    bg = "none" })
cfg.hi.set("GitSignsChange",    { style = "none", fg = colors.variants.gray[06],    bg = "none" })
cfg.hi.set("GitSignsDelete",    { style = "none", fg = colors.variants.red[10],    bg = "none" })
cfg.hi.set("GitSignsChange",    { style = "none", fg = colors.variants.gray[06],    bg = "none" })
cfg.hi.set("GitSignsCurrentLineBlame",    { style = "none", fg = colors.variants.green[04],    bg = "none" })

cfg.hi.link("Conditional",                         "Keyword")
cfg.hi.link("Statement",                           "Keyword")
cfg.hi.link("Include",                             "Keyword")
cfg.hi.link("xmlTagName",                          "Keyword")
cfg.hi.link("xmlAttrib",                           "Normal")
cfg.hi.link("xmlTag",                              "Keyword")
cfg.hi.link("xmlEndTag",                           "Keyword")
cfg.hi.link("htmlTagName",                         "Normal")
cfg.hi.link("htmlTag",                             "Keyword")
cfg.hi.link("htmlEndTag",                          "Keyword")
cfg.hi.link("htmlSpecialTagName",                  "Normal")
cfg.hi.link("htmlArg",                             "Keyword")
cfg.hi.link("jsFrom",                              "Keyword")
cfg.hi.link("jsExport",                            "Keyword")
cfg.hi.link("jsExportDefault",                     "Keyword")
cfg.hi.link("jsImport",                            "Keyword")
cfg.hi.link("typescriptFunctionMethod",            "Normal")
cfg.hi.link("typescriptES6SetMethod",              "Normal")
cfg.hi.link("typescriptDOMDocMethod",              "Normal")
cfg.hi.link("typescriptHeadersMethod",             "Normal")
cfg.hi.link("typescriptCacheMethod",               "Normal")
cfg.hi.link("typescriptServiceWorkerMethod",       "Normal")
cfg.hi.link("typescriptBOMNavigatorProp",          "Normal")
cfg.hi.link("typescriptDOMFormProp",               "Normal")
cfg.hi.link("typescriptProp",                      "Normal")
cfg.hi.link("typescriptBOMLocationMethod",         "Normal")
cfg.hi.link("typescriptPaymentShippingOptionProp", "Normal")
cfg.hi.link("typescriptRepeat",                    "Keyword")
cfg.hi.link("typescriptExport",                    "jsExport")
cfg.hi.link("typescriptImport",                    "jsImport")
cfg.hi.link("typescriptPredefinedType",            "Normal")
cfg.hi.link("typescriptVariable",                  "Keyword")
cfg.hi.link("typescriptAmbientDeclaration",        "Keyword")
cfg.hi.link("typescriptModule",                    "Keyword")
cfg.hi.link("typescriptOperator",                  "Keyword")
cfg.hi.link("typescriptDOMNodeProp",               "Normal")
cfg.hi.link("typescriptRequestProp",               "Normal")
cfg.hi.link("typescriptReflectMethod",             "Normal")
cfg.hi.link("typescriptStringMethod",              "Normal")
cfg.hi.link("typescriptArrayMethod",               "Normal")
cfg.hi.link("typescriptResponseProp",              "Normal")
cfg.hi.link("typescriptPromiseStaticMethod",       "Normal")
cfg.hi.link("typescriptPromiseMethod",             "Normal")
cfg.hi.link("typescriptMethodAccessor",            "Keyword")
cfg.hi.link("typescriptDOMDocProp",                "Normal")
cfg.hi.link("typescriptBOMHistoryProp",            "Normal")
cfg.hi.link("typescriptPaymentMethod",             "Normal")
cfg.hi.link("typescriptDOMStorageMethod",          "Normal")
cfg.hi.link("typescriptEnumKeyword",               "Keyword")
cfg.hi.link("typescriptCastKeyword",               "Keyword")
cfg.hi.link("typescriptDOMEventProp",              "Normal")
cfg.hi.link("typescriptObjectStaticMethod",        "Normal")
cfg.hi.link("typescriptXHRProp",                   "Normal")
cfg.hi.link("typescriptURLUtilsProp",              "Normal")
cfg.hi.link("typescriptFileReaderProp",            "Normal")
cfg.hi.link("typescriptMessage",                   "Normal")
cfg.hi.link("typescriptDOMNodeMethod",             "Normal")
cfg.hi.link("typescriptJSONStaticMethod",          "Normal")
cfg.hi.link("goType",                              "Keyword")
cfg.hi.link("goSignedInts",                        "Keyword")
cfg.hi.link("goConditional",                       "Keyword")
cfg.hi.link("goRepeat",                            "Keyword")
cfg.hi.link("goDeclaration",                       "Keyword")
cfg.hi.link("goType",                              "Normal")
cfg.hi.link("goSignedInts",                        "Normal")
cfg.hi.link("StorageClass",                        "Keyword")
cfg.hi.link("cssTagName",                          "Normal")
cfg.hi.link("pugAttributes",                       "Keyword")
cfg.hi.link("makeSString",                         "Normal")
-- stylua: ignore end
