local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local autoformat = function(bufnr)
	vim.lsp.buf.format({
		-- timeout_ms = 5000,
		filter = function(candidate)
			return candidate.name ~= "lua_ls"
				and candidate.name ~= "tsserver"
				and candidate.name ~= "gopls"
				and candidate.name ~= "csharpier"
				and candidate.name ~= "black"
		end,
		bufnr = bufnr,
	})
end

function LspOnAttach(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- if client.supports_method("textDocument/formatting") then
	vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = augroup,
		buffer = bufnr,
		callback = function()
			autoformat(bufnr)
		end,
	})
	-- end

	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.keymap.set({ "i", "n" }, "<C-L><C-L>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.keymap.set("n", "<C-L><C-R>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	vim.keymap.set({ "i", "n" }, "<C-L><C-A>", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	vim.keymap.set({ "i", "n" }, "<C-L><C-I>", "<cmd>TSToolsAddMissingImports<CR>", opts)

	vim.keymap.set({ "i", "n" }, "<C-L><C-O>", function()
		local import_all = require("nvim-lsp-ts-utils.import-all")

		vim.lsp.buf.execute_command({
			command = "_typescript.organizeImports",
			arguments = { vim.api.nvim_buf_get_name(0) },
			title = "",
		})

		vim.defer_fn(function()
			import_all()
			autoformat(0)
		end, 100)
	end)
end

return require("packer").startup({
	function(use)
		use({ "lewis6991/impatient.nvim" })

		use({
			"neovim/nvim-lspconfig",
			config = function()
				vim.cmd([[ sign define DiagnosticSignHint text=› texthl=DiagnosticSignHint linehl= numhl= ]])
				vim.cmd([[ sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo linehl= numhl= ]])
				vim.cmd([[ sign define DiagnosticSignWarn text=? texthl=DiagnosticSignWarn linehl= numhl= ]])
				vim.cmd([[ sign define DiagnosticSignError text=‼ texthl=DiagnosticSignError linehl= numhl= ]])

				for _, client in pairs(vim.lsp.get_active_clients()) do
					if client.name ~= "null-ls" then
						client.stop()
					end
				end
				-- local capabilities = vim.lsp.protocol.make_client_capabilities()
				--

				local lspconfig = require("lspconfig")
				--
				-- lspconfig.tsserver.setup({
				-- 	on_attach = function(client, bufnr)
				-- 		-- local ts_utils = require("nvim-lsp-ts-utils")
				-- 		-- ts_utils.setup({})
				-- 		on_attach(client, bufnr)
				-- 	end,
				-- 	-- capabilities = capabilities,
				-- 	init_options = {
				-- 		hostInfo = "neovim",
				-- 		preferences = {
				-- 			importModuleSpecifierPreference = "non-relative",
				-- 			-- includeInlayParameterNameHints = "all",
				-- 			-- includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				-- 			-- includeInlayFunctionParameterTypeHints = true,
				-- 			-- includeInlayVariableTypeHints = true,
				-- 			-- includeInlayPropertyDeclarationTypeHints = true,
				-- 			-- includeInlayFunctionLikeReturnTypeHints = true,
				-- 			-- includeInlayEnumMemberValueHints = true,
				-- 		},
				-- 	},
				-- })

				lspconfig.lua_ls.setup({
					on_init = function(client)
						client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {

							diagnostics = { globals = { "vim" } },
							runtime = {
								-- Tell the language server which version of Lua you're using
								-- (most likely LuaJIT in the case of Neovim)
								version = "LuaJIT",
								unicodeName = true,
							},
							-- Make the server aware of Neovim runtime files
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.VIMRUNTIME,
									-- Depending on the usage, you might want to add additional paths here.
									-- "${3rd}/luv/library"
									-- "${3rd}/busted/library",
								},
								-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
								-- library = vim.api.nvim_get_runtime_file("", true)
							},
						})
					end,
					on_attach = function(client, bufnr)
						LspOnAttach(client, bufnr)
					end,
					settings = {
						Lua = {},
					},
				})

				lspconfig.prismals.setup({
					on_attach = function(client, bufnr)
						LspOnAttach(client, bufnr)
					end,
				})

				lspconfig.gopls.setup({
					on_attach = function(client, bufnr)
						LspOnAttach(client, bufnr)
					end,
				})

				lspconfig.omnisharp.setup({
					cmd = { "dotnet", "/usr/lib/omnisharp-roslyn/OmniSharp.dll" },
					on_attach = function(client, bufnr)
						LspOnAttach(client, bufnr)
					end,
				})

				lspconfig.pyright.setup({
					on_attach = function(client, bufnr)
						LspOnAttach(client, bufnr)
					end,
				})

				lspconfig.ccls.setup({
					on_attach = function(client, bufnr)
						LspOnAttach(client, bufnr)
					end,
				})

				lspconfig.zls.setup({
					on_attach = function(client, bufnr)
						LspOnAttach(client, bufnr)
					end,
				})
			end,
		})

		use({
			"jose-elias-alvarez/null-ls.nvim",
			requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
			config = function()
				local null_ls = require("null-ls")
				null_ls.setup({
					sources = {
						null_ls.builtins.formatting.stylua,
						null_ls.builtins.formatting.prettierd,
						null_ls.builtins.formatting.csharpier,
						null_ls.builtins.formatting.black,
						null_ls.builtins.diagnostics.eslint_d.with({ extra_args = { "--quiet" } }),
						null_ls.builtins.code_actions.gitsigns,
						null_ls.builtins.code_actions.refactoring,
						null_ls.builtins.diagnostics.golangci_lint,
						null_ls.builtins.hover.dictionary,
					},
				})
			end,
		})
		--
		-- use({
		-- 	"ray-x/lsp_signature.nvim",
		-- 	config = function()
		-- 		require("lsp_signature").setup({
		-- 			hint_prefix = " ",
		-- 			hint_scheme = "Comment",
		-- 		})
		-- 	end,
		-- })

		use({
			"folke/trouble.nvim",
			requires = "kyazdani42/nvim-web-devicons",
			config = function()
				require("trouble").setup({
					use_diagnostic_signs = true,
					-- your configuration comes here
					-- or leave it empty to use the default settings
					-- refer to the configuration section below
				})
			end,
		})

		use({
			"feline-nvim/feline.nvim",
			config = function()
				local colors = require("colors")

				local provider_vi_mode = require("feline.providers.vi_mode")
				local provider_file = require("feline.providers.file")
				local components = {
					active = {},
					inactive = {},
				}

				table.insert(components.active, {})
				table.insert(components.active, {})
				table.insert(components.active, {})

				table.insert(components.inactive, {})
				table.insert(components.inactive, {})

				table.insert(components.active[1], {
					left_sep = " ",
					provider = function()
						local symbols = {
							["NORMAL"] = "·",
							["INSERT"] = "○",
							["VISUAL"] = "⏺",
							["SELECT"] = "⏺",
							["BLOCK"] = "⏹",
							["LINES"] = "⚌",
							["REPLACE"] = "□",
							["V-REPLACE"] = "□",
							["COMMAND"] = ":",
							["CONFIRM"] = "?",
						}

						return (symbols[provider_vi_mode.get_vim_mode()] or " ") .. " "
					end,
				})

				table.insert(components.active[1], {
					icon = "",
					provider = {
						name = "file_info",
						opts = {
							file_modified_icon = "⋯ ",
							file_readonly_icon = "🔒",
						},
					},
					hl = {
						style = "bold",
					},
				})

				table.insert(components.active[3], {
					provider = {
						name = "file_type",
					},
					hl = {
						style = "bold",
					},
					right_sep = {
						str = " ",
					},
				})

				table.insert(components.inactive[1], {
					provider = " · ",
					hl = {
						bg = colors.muted.primary,
						fg = colors.muted.secondary,
					},
				})

				table.insert(components.inactive[1], {
					icon = "",
					provider = {
						name = "file_info",
						opts = {
							file_modified_icon = "⋯ ",
							file_readonly_icon = "🔒",
						},
					},
					hl = {
						style = "bold",
						bg = colors.muted.primary,
						fg = colors.muted.secondary,
					},
				})

				require("feline").setup({
					theme = {
						fg = colors.bright.secondary,
						bg = colors.bright.primary,
					},
					components = components,
				})
			end,
		})
		--
		-- use({
		--     "debugloop/telescope-undo.nvim",
		--     config = function()
		--         require("telescope").load_extension("undo")
		--     end,
		-- })

		use({
			"nvim-telescope/telescope.nvim",
			requires = { { "nvim-lua/plenary.nvim", "debugloop/telescope-undo.nvim" } },
			config = function()
				local trouble = require("trouble.providers.telescope")
				local sources = require("trouble.sources.telescope")
				local actions = require("telescope.actions")
				local actions_file_browser = require("telescope").extensions.file_browser.actions
				-- local actions_undo = require("telescope-undo.actions")

				require("telescope").setup({
					defaults = {
						layout_strategy = "vertical",
						layout_config = { height = 0.95 },
						mappings = {
							i = {
								["<Esc>"] = actions.close,
								["<C-T>"] = sources.open,
							},
							n = { ["<C-T>"] = sources.open },
						},
					},
					pickers = {
						-- ...
						-- ...
					},
					extensions = {
						file_browser = {
							mappings = {
								["i"] = {
									["<C-N>"] = actions_file_browser.create_from_prompt,
								},
							},
						},
						-- undo = {
						-- 	mappings = {
						-- 		["i"] = {
						-- 			["<CR>"] = actions_undo.restore,
						-- 		},
						-- 	},
						-- },
						-- ...
					},
				})

				local cfg = require("cfg")

				local themes = require("telescope.themes")

				local layout = function(opts)
					return themes.get_dropdown(cfg.tbl.merge({
						layout_strategy = "vertical",
						layout_config = { height = { padding = 0 }, width = { padding = 0 } },
						border = true,
						prompt_title = false,
						dynamic_preview_title = true,
						results_title = false,
						preview_title = "",
						selection_caret = "▶ ",
						prompt_prefix = "❭ ",
						multi_icon = "⬛",
						path_display = { shorten = 3 },
						borderchars = {
							--       { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
							prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
							-- results = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
							preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
							results = { " ", "░", " ", " ", " ", " ", " ", " " },
							-- preview = { " ", " ", " ", " ", " ", " ", " ", " " },
						},
					}, opts or {}))
				end

				vim.keymap.set("n", "<C-P><C-P>", function()
					require("telescope.builtin").find_files(layout({ hidden = true, follow = true }))
				end, { silent = true })

				vim.keymap.set("n", "<C-P><C-B>", function()
					require("telescope.builtin").buffers()
				end, { silent = true })

				vim.keymap.set("n", "<C-P><C-G>", function()
					require("telescope.builtin").live_grep(layout())
				end, { silent = true })

				vim.keymap.set("n", "<C-P><C-A>", function()
					require("telescope.builtin").grep_string(layout({
						only_sort_text = true,
						search = "",
					}))
				end, { silent = true })

				vim.keymap.set("n", "<C-P><C-C>", function()
					require("telescope.builtin").resume(layout())
				end, { silent = true })

				vim.keymap.set("n", "<C-P><C-L>", function()
					require("telescope.builtin").lsp_dynamic_workspace_symbols(layout())
				end, { silent = true })

				vim.keymap.set("n", "<C-P><C-T>", function()
					require("telescope.builtin").grep_string(layout())
				end, { silent = true })

				vim.keymap.set("n", "<C-P><C-F>", function()
					require("telescope").extensions.file_browser.file_browser(layout({ path = "%:p:h" }))
				end, { silent = true })

				vim.keymap.set("n", "gd", function()
					require("telescope.builtin").lsp_definitions(layout())
				end, { silent = true })

				vim.keymap.set("n", "gi", function()
					require("telescope.builtin").lsp_implementations(layout())
				end, { silent = true })

				vim.keymap.set("n", "gD", function()
					require("telescope.builtin").lsp_type_definitions(layout())
				end, { silent = true })

				vim.keymap.set("n", "gr", function()
					require("telescope.builtin").lsp_references(layout())
				end, { silent = true })

				vim.keymap.set("n", "<C-P><C-U>", function()
					require("telescope").extensions.undo.undo(layout())
				end, { silent = true })
			end,
		})

		use({
			"lewis6991/hover.nvim",
			config = function()
				require("hover").setup({
					init = function()
						-- Require providers
						require("hover.providers.lsp")
						-- require('hover.providers.gh')
						-- require('hover.providers.gh_user')
						-- require('hover.providers.jira')
						-- require('hover.providers.man')
						require("hover.providers.dictionary")
					end,
					preview_opts = {
						border = nil,
					},
					-- Whether the contents of a currently open hover window should be moved
					-- to a :h preview-window when pressing the hover keymap.
					preview_window = false,
					title = true,
				})

				-- Setup keymaps
				vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
				vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
			end,
		})

		use({
			"hrsh7th/nvim-cmp",
			config = function()
				local cmp = require("cmp")
				local cmp_compare = require("cmp.config.compare")
				local cmp_keymap = require("cmp.utils.keymap")

				local has_words_before = function()
					local line, col = unpack(vim.api.nvim_win_get_cursor(0))
					return col ~= 0
						and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
				end

				local luasnip = require("luasnip")

				cmp.setup({
					sorting = {
						comparators = {
							cmp_compare.exact,
							cmp_compare.locality,
							cmp_compare.scopes,
						},
					},
					snippet = {
						-- REQUIRED - you must specify a snippet engine
						expand = function(args)
							require("luasnip").lsp_expand(args.body)
						end,
					},
					window = {
						completion = cmp.config.window.bordered(),
						documentation = cmp.config.window.bordered(),
					},
					mapping = cmp.mapping.preset.insert({
						["<C-b>"] = cmp.mapping.scroll_docs(-4),
						-- ["<C-f>"] = cmp.mapping.scroll_docs(4),
						["<C-Space>"] = cmp.mapping.complete(),
						["<C-e>"] = cmp.mapping.abort(),
						["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
						["<C-o>"] = cmp.mapping.select_next_item(),
						["<Tab>"] = cmp.mapping(function(fallback)
							if luasnip.expandable() then
								luasnip.expand()
							elseif has_words_before() then
								cmp.complete()
							else
								if vim.fn.pumvisible() == 0 then
									fallback()
								else
									vim.api.nvim_feedkeys(cmp_keymap.t("<C-p>"), "in", true)
								end
							end
						end, { "i", "s", "c" }),
						["<C-F>"] = cmp.mapping(function(fallback)
							if luasnip.jumpable() then
								luasnip.jump(1)
							else
								cmp.mapping.scroll_docs(4)
							end
						end, { "i", "s", "c" }),
					}),
					-- mapping = {
					-- 	["<C-PageDown>"] = cmp.mapping.scroll_docs(-4),
					-- 	["<C-PageUp>"] = cmp.mapping.scroll_docs(4),
					-- 	-- ["<C-P>"] = cmp.mapping.complete(),
					--
					-- 	["<C-E>"] = cmp.mapping(function()
					-- 		if luasnip.choice_active() then
					-- 			luasnip.change_choice(1)
					-- 		else
					-- 			cmp.mapping.abort()
					-- 		end
					-- 	end),
					-- 	["<CR>"] = cmp.mapping.confirm({ select = true }),
					-- 	["<C-F>"] = cmp.mapping(function(fallback)
					-- 		if luasnip.jumpable() then
					-- 			luasnip.jump(1)
					-- 		elseif has_words_before() then
					-- 			cmp.complete()
					-- 		else
					-- 			fallback()
					-- 		end
					-- 	end, { "i", "s", "c" }),
					-- 	["<C-O>"] = cmp.mapping(function(fallback)
					-- 		if cmp.visible() then
					-- 			cmp.select_next_item()
					-- 		else
					-- 			fallback()
					-- 		end
					-- 	end, { "i", "s", "c" }),
					-- 	["<C-P>"] = cmp.mapping(function(fallback)
					-- 		if cmp.visible() then
					-- 			cmp.select_prev_item()
					-- 		else
					-- 			fallback()
					-- 		end
					-- 	end, { "i", "s", "c" }),
					-- },
					sources = cmp.config.sources({
						{ name = "nvim_lsp_signature_help" },
						{ name = "nvim_lsp" },
						{ name = "path", keyword_length = 1 },
						{ name = "dictionary", keyword_length = 2 },
						-- { name = "luasnip" },
						{ name = "orgmode" },
					}, {
						{ name = "buffer" },
					}),
				})

				-- Set configuration for specific filetype.
				cmp.setup.filetype("gitcommit", {
					sources = cmp.config.sources({
						{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
					}, {
						{ name = "buffer" },
					}),
				})

				cmp.setup.cmdline({ "/", "?" }, {
					mapping = cmp.mapping.preset.cmdline(),
					sources = {
						{ name = "buffer" },
					},
				})

				-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
				cmp.setup.cmdline(":", {
					mapping = cmp.mapping.preset.cmdline(),
					sources = cmp.config.sources({
						{ name = "path" },
					}, {
						{ name = "cmdline" },
					}),
					matching = { disallow_symbol_nonprefix_matching = false },
				})
			end,
		})

		use({ "hrsh7th/cmp-nvim-lsp-signature-help" })
		use({ "hrsh7th/cmp-buffer" })
		use({ "hrsh7th/cmp-path" })
		use({ "hrsh7th/cmp-cmdline" })

		use({
			"uga-rosa/cmp-dictionary",
			config = function()
				require("cmp_dictionary").setup({
					dic = {
						["lilypond"] = {
							"$LILYDICTPATH/grobs",
							"$LILYDICTPATH/keywords",
							"$LILYDICTPATH/musicFunctions",
							"$LILYDICTPATH/articulations",
							"$LILYDICTPATH/grobProperties",
							"$LILYDICTPATH/paperVariables",
							"$LILYDICTPATH/headerVariables",
							"$LILYDICTPATH/contextProperties",
							"$LILYDICTPATH/clefs",
							"$LILYDICTPATH/repeatTypes",
							"$LILYDICTPATH/languageNames",
							"$LILYDICTPATH/accidentalsStyles",
							"$LILYDICTPATH/scales",
							"$LILYDICTPATH/musicCommands",
							"$LILYDICTPATH/markupCommands",
							"$LILYDICTPATH/contextsCmd",
							"$LILYDICTPATH/dynamics",
							"$LILYDICTPATH/contexts",
							"$LILYDICTPATH/translators",
						},
					},
				})
			end,
		})

		use("hrsh7th/cmp-nvim-lsp")

		-- use("saadparwaiz1/cmp_luasnip")

		use("L3MON4D3/LuaSnip")

		use({
			"junegunn/vim-easy-align",
			config = function()
				vim.keymap.set("x", "ga", "<Plug>(EasyAlign)")
			end,
		})

		use({
			"mg979/vim-visual-multi",
			config = function()
				local cfg = require("cfg")

				local colors = require("colors")

				vim.g.VM_theme_set_by_colorscheme = 1
				vim.g.VM_highlight_matches = "hi! Search guibg="
					.. colors.muted.selection
					.. " guifg="
					.. colors.bright.alert

				vim.g.VM_maps = {
					Undo = "u",
					Redo = "<C-R>",
					h = "<Left>",
					j = "<Up>",
					k = "<Right>",
					l = "<Down>",
				}
				vim.g.VM_leader = "<Space>"

				cfg.hi.set("VM_Cursor", { fg = colors.bright.primary, bg = colors.bright.alert })
				cfg.hi.set("VM_Extend", { bg = colors.bright.alert, fg = colors.black, style = "bold" })
				cfg.hi.link("VM_Mono", "Search")
				cfg.hi.link("VM_Insert", "IncSearch")
			end,
		})

		use({
			"lewis6991/gitsigns.nvim",
			config = function()
				require("gitsigns").setup({
					current_line_blame = false,
					current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d>   <summary> ﲕ ",
					current_line_blame_opts = {
						virt_text = true,
						virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
						delay = 2000,
						ignore_whitespace = true,
					},
					on_attach = function(bufnr)
						local gs = package.loaded.gitsigns

						local function map(mode, l, r, opts)
							opts = opts or {}
							opts.buffer = bufnr
							vim.keymap.set(mode, l, r, opts)
						end

						-- Navigation
						map("n", "]c", function()
							if vim.wo.diff then
								return "]c"
							end
							vim.schedule(function()
								gs.next_hunk()
							end)
							return "<Ignore>"
						end, { expr = true })

						map("n", "[c", function()
							if vim.wo.diff then
								return "[c"
							end
							vim.schedule(function()
								gs.prev_hunk()
							end)
							return "<Ignore>"
						end, { expr = true })

						-- Actions
						map({ "n", "v" }, "<C-G><C-S>", ":Gitsigns stage_hunk<CR>")
						map({ "n", "v" }, "<C-G><C-R><C-H>", ":Gitsigns reset_hunk<CR>")
						map("n", "<C-G><C-B>", gs.stage_buffer)
						map("n", "<C-G><C-U><C-B>", gs.undo_stage_hunk)
						map("n", "<C-G><C-R><C-B>", gs.reset_buffer)
						map("n", "<C-G><C-P>", gs.preview_hunk)
						-- map("n", "<C-G><C-L>", function()
						-- 	gs.blame_line({ full = true })
						-- end)
						map("n", "<C-G><C-W>", gs.toggle_current_line_blame)
						map("n", "<C-G><C-D>", gs.diffthis)
						-- map("n", "<leader>hD", function()
						-- 	gs.diffthis("~")
						-- end)
						map("n", "<C-G><C-X>", gs.toggle_deleted)

						-- Text object
						map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
					end,
				})
			end,
		})

		use({
			"terrortylor/nvim-comment",
			config = function()
				require("nvim_comment").setup({
					line_mapping = "<C-C><C-C>",
					-- Visual/Operator mapping left hand side
					operator_mapping = "<C-C>",
				})
			end,
		})

		use({
			"kana/vim-submode",
			config = function()
				vim.fn["submode#enter_with"]("window", "n", "", "<C-W>")
				vim.fn["submode#leave_with"]("window", "n", "", "<Esc>")
                -- stylua: ignore
                for _, key in pairs({
                    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
                    "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
                }) do
                    vim.fn["submode#map"]("window", "n", "", key, "<C-W>" .. key)
                    vim.fn["submode#map"]("window", "n", "", string.upper(key), "<C-W>" .. string.upper(key))
                    vim.fn["submode#map"]("window", "n", "", "<C-" .. key .. ">", "<C-W>" .. "<C-" .. key .. ">")
                end
				vim.fn["submode#map"]("window", "n", "", "_", "<C-W>_")
				vim.fn["submode#map"]("window", "n", "", "+", "3<C-W>+")
				vim.fn["submode#map"]("window", "n", "", "-", "3<C-W>-")
				vim.fn["submode#map"]("window", "n", "", "=", "3<C-W>=")
				vim.fn["submode#map"]("window", "n", "", "<bar>", "3<C-W><bar>")
			end,
		})

		use({
			"nvim-telescope/telescope-file-browser.nvim",
			config = function()
				require("telescope").load_extension("file_browser")
			end,
		})

		-- use({
		-- 	"pwntester/octo.nvim",
		-- 	requires = {
		-- 		"nvim-lua/plenary.nvim",
		-- 		"nvim-telescope/telescope.nvim",
		-- 		"kyazdani42/nvim-web-devicons",
		-- 	},
		-- 	config = function()
		-- 		require("octo").setup({
		-- 			github_hostname = "github.com",
		-- 			reaction_viewer_hint_icon = " •",
		-- 		})
		-- 	end,
		-- })

		-- use({
		-- 	"folke/which-key.nvim",
		-- 	config = function()
		-- 		require("which-key").setup({
		-- 			-- your configuration comes here
		-- 			-- or leave it empty to use the default settings
		-- 			-- refer to the configuration section below
		-- 		})
		-- 	end,
		-- })
		--
		-- use({
		-- 	"jose-elias-alvarez/nvim-lsp-ts-utils",
		-- })

		use({
			"pmizio/typescript-tools.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
			opts = {},
			config = function()
				require("typescript-tools").setup({
					on_attach = function(client, bufnr)
						LspOnAttach(client, bufnr)
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
					end,
					handlers = {},
					settings = {
						-- spawn additional tsserver instance to calculate diagnostics on it
						separate_diagnostic_server = true,
						-- "change"|"insert_leave" determine when the client asks the server about diagnostic
						publish_diagnostic_on = "insert_leave",
						-- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
						-- "remove_unused_imports"|"organize_imports") -- or string "all"
						-- to include all supported code actions
						-- specify commands exposed as code_actions
						expose_as_code_action = {},
						-- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
						-- not exists then standard path resolution strategy is applied
						tsserver_path = nil,
						-- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
						-- (see 💅 `styled-components` support section)
						tsserver_plugins = {},
						-- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
						-- memory limit in megabytes or "auto"(basically no limit)
						tsserver_max_memory = "auto",
						-- described below
						tsserver_format_options = {},
						tsserver_file_preferences = {
							importModuleSpecifierPreference = "non-relative",
						},
						-- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
						complete_function_calls = false,
					},
				})
			end,
		})

		use({
			"ThePrimeagen/refactoring.nvim",
			requires = {
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-treesitter/nvim-treesitter" },
			},
			config = function()
				require("refactoring").setup({})
			end,
		})

		use({
			"nvim-treesitter/nvim-treesitter",
			config = function()
				require("nvim-treesitter.configs").setup({
					playground = {
						enable = true,
						disable = {},
						updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
						persist_queries = false, -- Whether the query persists across vim sessions
						keybindings = {
							toggle_query_editor = "o",
							toggle_hl_groups = "i",
							toggle_injected_languages = "t",
							toggle_anonymous_nodes = "a",
							toggle_language_display = "I",
							focus_language = "f",
							unfocus_language = "F",
							update = "R",
							goto_node = "<cr>",
							show_help = "?",
						},
					},
					-- A list of parser names, or "all"
					ensure_installed = { "lua", "zig" },
					highlight = {
						enable = true,
						additional_vim_regex_highlighting = { "org" },
					},
				})
			end,
		})

		use({ "nvim-treesitter/playground" })

		use({
			"martineausimon/nvim-lilypond-suite",
			requires = { "MunifTanjim/nui.nvim" },
			config = function()
				vim.api.nvim_create_autocmd({ "Filetype" }, {
					group = vim.api.nvim_create_augroup("lilypond_mappings", { clear = true }),
					pattern = { "lilypond" },
					callback = function()
						vim.keymap.set("v", "<C-L>", function()
							require("nvls.lilypond").quickplayer()
						end, { silent = true })
						vim.keymap.set("n", "<C-L>", function()
							vim.api.nvim_feedkeys("gv", "n", false)
							require("nvls.lilypond").quickplayer()
						end, { silent = true })
					end,
				})

				require("nvls").setup({
					lilypond = {
						mappings = {
							player = "<F3>",
							compile = "<F5>",
							open_pdf = "<F6>",
							switch_buffers = "<A-Space>",
							insert_version = "<F4>",
							hyphenation = "<F12>",
							hyphenation_change_lang = "<F11>",
							insert_hyphen = "<leader>ih",
							add_hyphen = "<leader>ah",
							del_next_hyphen = "<leader>dh",
							del_prev_hyphen = "<leader>dH",
							del_selected_hyphen = "<leader>dh",
						},
						options = {
							pitches_language = "default",
							output = "pdf",
							main_file = "main.ly",
							main_folder = "%:p:h",
							include_dir = "$HOME",
							hyphenation_language = "en_DEFAULT",
						},
						highlights = {
							lilyString = { link = "String" },
							lilyDynamic = { bold = true },
							lilyComment = { link = "Comment" },
							lilyNumber = { link = "Number" },
							lilyVar = { link = "Tag" },
							lilyBoolean = { link = "Boolean" },
							lilySpecial = { bold = true },
							lilyArgument = { link = "Type" },
							lilyScheme = { link = "Special" },
							lilyLyrics = { link = "Special" },
							lilyMarkup = { bold = true },
							lilyFunction = { link = "Statement" },
							lilyArticulation = { link = "PreProc" },
							lilyContext = { link = "Type" },
							lilyGrob = { link = "Include" },
							lilyTranslator = { link = "Type" },
							lilyPitch = { link = "Function" },
							lilyChord = {
								ctermfg = "lightMagenta",
								fg = "lightMagenta",
								bold = true,
							},
						},
					},
					latex = {
						mappings = {
							compile = "<F5>",
							open_pdf = "<F6>",
							lilypond_syntax = "<F3>",
						},
						options = {
							clean_logs = false,
							include_dir = nil,
						},
					},
					player = {
						mappings = {
							quit = "q",
							play_pause = "p",
							loop = "<A-l>",
							backward = "h",
							small_backward = "<S-h>",
							forward = "l",
							small_forward = "<S-l>",
							decrease_speed = "j",
							increase_speed = "k",
							halve_speed = "<S-j>",
							double_speed = "<S-k>",
						},
						options = {
							row = "2%",
							col = "99%",
							width = "37",
							height = "1",
							border_style = "single",
							winhighlight = "Normal:Normal,FloatBorder:Normal",
							mpv_flags = {
								"--msg-level=cplayer=no,ffmpeg=no",
								"--loop",
								"--config-dir=/dev/null",
							},
						},
					},
				})

				vim.api.nvim_create_autocmd("BufWritePost", {
					group = vim.api.nvim_create_augroup("LilyPond", { clear = true }),
					pattern = { "*.ly" },
					callback = function()
						vim.api.nvim_command("silent LilyCmp")
					end,
				})
			end,
		})

		use({
			"pocco81/auto-save.nvim",
			config = function()
				require("auto-save").setup({

					condition = function(buf)
						if vim.fn.expand("%:t") == "notes.org" then
							return true
						else
							return false
						end
					end,
				})
			end,
		})

		use({
			"nvim-orgmode/orgmode",
			requires = {},
			config = function()
				require("orgmode").setup({
					-- win_split_mode = function(name)
					-- 	local bufnr = vim.api.nvim_create_buf(false, true)
					-- 	--- Setting buffer name is required
					-- 	vim.api.nvim_buf_set_name(bufnr, name)
					--
					-- 	local fill = 0.8
					-- 	local width = math.floor((vim.o.columns * fill))
					-- 	local height = math.floor((vim.o.lines * fill))
					-- 	local row = math.floor((((vim.o.lines - height) / 2) - 1))
					-- 	local col = math.floor(((vim.o.columns - width) / 2))
					--
					-- 	vim.api.nvim_open_win(bufnr, true, {
					-- 		relative = "editor",
					-- 		width = width,
					-- 		height = height,
					-- 		row = row,
					-- 		col = col,
					-- 		style = "minimal",
					-- 		border = "rounded",
					-- 	})
					-- end,
					org_agenda_files = { "~/my/org/*" },
					org_default_notes_file = "~/my/org/notes.org",
				})
			end,
		})

		use({
			"MunifTanjim/prettier.nvim",
			config = function()
				require("prettier").setup({})
			end,
		})
	end,
	config = {
		display = {
			working_sym = "•",
		},
	},
})
