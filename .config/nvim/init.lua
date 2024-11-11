local colors = require("colors")
local cfg = require("cfg")

-- TODO: is it possible to set via packer.nvim?
local config_path = vim.fn.stdpath("config") .. "/init.lua"
local config_path_packages = vim.fn.stdpath("config") .. "/?.lua"

if not string.find(package.path, ";" .. config_path_packages) then
	package.path = package.path .. ";" .. config_path_packages
end

function ReloadConfig()
	require("plenary.reload").reload_module("lambda")
	require("plenary.reload").reload_module("cfg")
	require("plenary.reload").reload_module("colors")
	require("plenary.reload").reload_module("init")
	require("plenary.reload").reload_module("plugins")
	require("plenary.reload").reload_module("snippets")
	require("plugins")
	vim.cmd([[ source ]] .. config_path .. [[ | PackerCompile ]])
	require("init")
end

vim.api.nvim_create_autocmd({ "Filetype" }, {
	group = vim.api.nvim_create_augroup("filetype_override", { clear = true }),
	pattern = { "typescriptreact" },
	callback = function()
		vim.opt_local.filetype = "typescriptreact"
	end,
})

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

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = vim.api.nvim_create_augroup("backup_extension", { clear = true }),
	pattern = { "*" },
	callback = function()
		-- TODO: rework to pure lua
		vim.cmd([[ let &bex = '.bak+' .. strftime("%m%dT%H%M") ]])
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
vim.o.backup = true
vim.o.backupdir = vim.fn.expand("$HOME/.local/share/nvim/backup")
vim.o.list = true
vim.o.listchars = "trail:·,tab:  "
vim.o.winminheight = 0
vim.o.equalalways = false
vim.o.linebreak = true
vim.o.showbreak = "🢱 "
vim.o.breakindent = true
vim.o.wrap = true
vim.o.guifont = "IosevkaTerm Nerd Font:h7"
vim.g.neovide_scroll_animation_length = 0.05
vim.o.winblend = 25
vim.o.pumblend = 15
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 10
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5
vim.g.neovide_cursor_animation_length = 0.01

-- vim.o.virtualedit = "all"

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

vim.keymap.set("n", "<Up>", "gk", { noremap = true })
vim.keymap.set("n", "<Down>", "gj", { noremap = true })
vim.keymap.set("n", "<Insert>", '"*p', { noremap = true })
vim.keymap.set("i", "<Insert>", '<C-\\><C-O>"*p', { noremap = true })
vim.keymap.set("c", "<Insert>", '<C-\\><C-O>"*p', { noremap = true })
-- cnoremap <expr> jk getcmdtype() =~ '^[/?]$' ? '<CR>' : 'jk'
--
local function is_command_search()
	local cmd_type = vim.fn.getcmdtype()
	return cmd_type == "/" or cmd_type == "?" or vim.fn.getcmdline():match("^'.,'.s/")
end

vim.keymap.set("c", "<C-S><C-W>", function()
	return is_command_search() and "<><Left>" or ""
end, { noremap = true, expr = true })

vim.keymap.set("n", "<C-G><C-L>", function()
	vim.fn.system("github-link " .. vim.fn.expand("%:p") .. " " .. vim.fn.line("."))
end)

require("rpc")
require("plugins")
require("snippets")

vim.diagnostic.config({
	virtual_text = {
		-- source = "always",  -- Or "if_many"
		prefix = "●", -- Could be '■', '▎', 'x'
	},
	severity_sort = true,
	float = {
		source = "if_many", -- Or "if_many"
	},
})

-- TODO: change inline colors with references
-- stylua: ignore start
cfg.hi.set("Special", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("SpecialKey", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("SpecialChar", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("SpecialComment", { style = "none", fg = colors.variants.gray[06], bg = "none" })
cfg.hi.set("NonText", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Directory", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("ErrorMsg", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("MoreMsg", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("ModeMsg", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("LineNr", { style = "none", fg = colors.variants.gray[04], bg = "none" })
cfg.hi.set("CursorLineNr", { style = "none", fg = colors.variants.purple[20], bg = "none" })
cfg.hi.set("CursorLine", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Question", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("StatusLine", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("StatusLineNC", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("VertSplit", { style = "none", fg = colors.variants.gray[04], bg = "none" })
cfg.hi.set("Title", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Visual", { style = "none", fg = colors.white, bg = colors.muted.selection })
cfg.hi.set("WarningMsg", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("WildMenu", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Folded", { style = "none", fg = colors.variants.gray[02], bg = "none" })
cfg.hi.set("FoldColumn", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("DiffAdd", { style = "none", fg = "none", bg = colors.variants.green[01] })
cfg.hi.set("DiffChange", { style = "none", fg = "none", bg = colors.variants.yellow[01] })
cfg.hi.set("DiffDelete", { style = "none", fg = colors.variants.red[06], bg = colors.variants.red[02] })
cfg.hi.set("DiffText", { style = "none", fg = colors.variants.yellow[22], bg = "none" })
cfg.hi.set("SignColumn", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Conceal", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("SpellBad", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("SpellCap", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("SpellRare", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("SpellLocal", { style = "none", fg = "none", bg = "none" })

cfg.hi.set("Pmenu", { style = "none", fg = colors.muted.secondary, bg = colors.variants.gray[02] })
cfg.hi.set("PmenuSel", { style = "bold", fg = colors.bright.alert, bg = colors.variants.gray[04] })
cfg.hi.set("PmenuSbar", { style = "none", fg = "none", bg = colors.variants.gray[02] })
cfg.hi.set("PmenuThumb", { style = "none", fg = "none", bg = colors.variants.gray[04] })

cfg.hi.set("NormalFloat", { style = "none", fg = colors.white, bg = colors.variants.yellow[01] })
cfg.hi.set("FloatBorder", { style = "none", fg = colors.white, bg = "none" })

cfg.hi.set("CmpItemAbbrDefault", { style = "none", fg = colors.muted.secondary, bg = "none" })
cfg.hi.set("CmpItemAbbrMatchDefault", { style = "none", fg = colors.bright.secondary, bg = "none" })

cfg.hi.set("TabLine", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("TabLineSel", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("TabLineFill", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("ColorColumn", { style = "none", fg = "none", bg = "#1C1C1C" })
cfg.hi.set("MatchParen", { style = "none", fg = colors.bright.alert, bg = "none" })
cfg.hi.set("Comment", { style = "italic", fg = colors.variants.yellow[05], bg = "none" })
cfg.hi.set("Constant", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Identifier", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("PreProc", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Type", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Ignore", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Error", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Todo", { style = "bold", fg = "none", bg = "none" })
cfg.hi.set("String", { style = "none", fg = colors.variants.gray[10], bg = colors.variants.gray[02] })
cfg.hi.set("Character", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Number", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Boolean", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Float", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Function", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Repeat", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Label", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Operator", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Keyword", { style = "bold", fg = "none", bg = "none" })
cfg.hi.set("Exception", { style = "bold", fg = colors.variants.red[17], bg = "none" })
cfg.hi.set("Define", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Macro", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("PreCondit", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("StorageClass", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Structure", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Typedef", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Tag", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Delimiter", { style = "none", fg = colors.variants.gray[07], bg = "none" })
cfg.hi.set("Debug", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("Normal", { style = "none", fg = colors.variants.gray[17], bg = colors.variants.purple[01] })
cfg.hi.set("Search", { style = "bold", fg = colors.bright.alert, bg = colors.variants.blue[03] })
cfg.hi.set("IncSearch", { style = "bold", fg = colors.black, bg = colors.bright.alert })
cfg.hi.set("EndOfBuffer", { style = "none", fg = colors.variants.gray[06], bg = "none" })
cfg.hi.set("Whitespace", { style = "none", fg = colors.bright.alert, bg = "none" })
cfg.hi.set("Modifier", { style = "bold", fg = "none", bg = colors.variants.yellow[01] })
cfg.hi.set("BracketFn", { style = "none", fg = colors.variants.gray[13], bg = "none" })
cfg.hi.set("BracketObj", { style = "none", fg = colors.variants.green[8], bg = colors.variants.green[2] })
cfg.hi.set("BracketArray", { style = "none", fg = colors.variants.gray[9], bg = colors.variants.purple[3] })

cfg.hi.set("DiagnosticUnderlineError", { style = "none", fg = colors.variants.red[14], bg = colors.variants.red[04] })
cfg.hi.set("DiagnosticUnderlineWarn", { style = "none", fg = "none", bg = colors.variants.yellow[01] })
cfg.hi.set("DiagnosticUnderlineInfo", { style = "none", fg = "none", bg = colors.variants.blue[03] })
cfg.hi.set("DiagnosticUnderlineHint", { style = "none", fg = "none", bg = colors.variants.gray[02] })

--cfg.hi.set("DiagnosticUnderlineError", { style = "none", fg = colors.variants.red[18], bg = colors.variants.red[05] })
cfg.hi.set("DiagnosticError", { style = "none", fg = colors.variants.red[14], bg = "none" })
cfg.hi.set("DiagnosticInfo", { style = "none", fg = colors.variants.gray[05], bg = "none" })
cfg.hi.set("DiagnosticHint", { style = "none", fg = colors.variants.gray[04], bg = "none" })

cfg.hi.set("goDeclaration", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("goConditional", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("goBuiltins", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("goCall", { style = "none", fg = "none", bg = "none" })
cfg.hi.set("goErr", { style = "none", fg = "none", bg = "none" })

cfg.hi.set("GitSignsAdd", { style = "none", fg = colors.variants.green[10], bg = "none" })
cfg.hi.set("GitSignsChange", { style = "none", fg = colors.variants.gray[06], bg = "none" })
cfg.hi.set("GitSignsDelete", { style = "none", fg = colors.variants.red[10], bg = "none" })
cfg.hi.set("GitSignsChange", { style = "none", fg = colors.variants.gray[06], bg = "none" })
cfg.hi.set("GitSignsCurrentLineBlame", { style = "none", fg = colors.variants.green[04], bg = "none" })

cfg.hi.link("Conditional", "Keyword")
cfg.hi.link("Statement", "Keyword")
cfg.hi.link("Include", "Keyword")

cfg.hi.link("@punctuation.special", "Modifier")
cfg.hi.link("@punctuation.special.typescript", "Modifier")
cfg.hi.link("@punctuation.bracket.fn.typescript", "BracketFn")
cfg.hi.link("@punctuation.bracket.obj.typescript", "BracketObj")
cfg.hi.link("@punctuation.bracket.array.typescript", "BracketArray")

cfg.hi.link("@include", "SpecialComment")
cfg.hi.link("@include.typescript", "SpecialComment")

cfg.hi.link("@repeat", "Keyword")
cfg.hi.link("@repeat.typescript", "Keyword")
cfg.hi.link("@string.template", "Normal")
