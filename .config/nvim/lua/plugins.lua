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

				local augroup_lsp_autoformat = vim.api.nvim_create_augroup("lsp_autoformat", { clear = true })

				local autoformat = function(bufnr)
					vim.lsp.buf.format({
						filter = function(clients)
							-- filter out clients that you don't want to use
							return vim.tbl_filter(function(client)
								return client.name ~= "sumneko_lua" and client.name ~= "tsserver"
							end, clients)
						end,
						bufnr = bufnr,
					})
				end

				local on_attach = function(client, bufnr)
					local opts = { noremap = true, silent = true, buffer = bufnr }

					vim.api.nvim_create_autocmd({ "BufWritePre" }, {
						group = augroup_lsp_autoformat,
						buffer = bufnr,
						callback = function()
							autoformat(bufnr)
						end,
					})

					-- Enable completion triggered by <c-x><c-o>
					vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

					-- Mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
					-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
					-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
					-- vim.api.nvim_buf_set_keymap(
					-- 	bufnr,
					-- 	"n",
					-- 	"<space>wa",
					-- 	"<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
					-- 	opts
					-- )
					-- vim.api.nvim_buf_set_keymap(
					-- 	bufnr,
					-- 	"n",
					-- 	"<space>wr",
					-- 	"<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
					-- 	opts
					-- )
					-- vim.api.nvim_buf_set_keymap(
					-- 	bufnr,
					-- 	"n",
					-- 	"<space>wl",
					-- 	"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
					-- 	opts
					-- )
					-- vim.api.nvim_buf_set_keymap(
					-- 	bufnr,
					-- 	"n",
					-- 	"<space>D",

					-- 	opts
					-- )
					vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
					vim.keymap.set({ "i", "n" }, "<C-L><C-L>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
					vim.keymap.set("n", "<C-L><C-R>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
					vim.keymap.set({ "i", "n" }, "<C-L><C-A>", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
					vim.keymap.set({ "i", "n" }, "<C-L><C-O>", function()
						vim.lsp.buf.execute_command({
							command = "_typescript.organizeImports",
							arguments = { vim.api.nvim_buf_get_name(0) },
							title = "",
						})
						vim.defer_fn(function()
							autoformat(0)
						end, 100)
					end)
					-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
					-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
				end

				require("lspconfig").tsserver.setup({
					on_attach = function(client, bufnr)
						local ts_utils = require("nvim-lsp-ts-utils")
						ts_utils.setup({})
						on_attach(client, bufnr)
					end,
					init_options = {
						hostInfo = "neovim",
						preferences = {
							importModuleSpecifierPreference = "non-relative",
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = true,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
				})

				require("lspconfig").sumneko_lua.setup({
					on_attach = function(client, bufnr)
						on_attach(client, bufnr)
					end,
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
							workspace = {
								library = {
									[vim.fn.expand("$VIMRUNTIME/lua")] = true,
									[vim.fn.expand("$VIMRUNTIME/lua/vim")] = true,
									[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
								},
							},
						},
					},
				})
				--
				-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
				-- 	vim.lsp.diagnostic.on_publish_diagnostics,
				-- 	{
				-- 		-- delay update diagnostics
				-- 		update_in_insert = false,
				-- 	}
				-- )
			end,
		})

		use({
			"jose-elias-alvarez/null-ls.nvim",
			requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
			config = function()
				require("null-ls").setup({
					sources = {
						require("null-ls").builtins.formatting.stylua,
						require("null-ls").builtins.formatting.prettierd,
						require("null-ls").builtins.diagnostics.eslint_d,
						require("null-ls").builtins.code_actions.gitsigns,
					},
				})
			end,
		})

		use({
			"ray-x/lsp_signature.nvim",
			config = function()
				require("lsp_signature").setup({
					hint_prefix = " ",
					hint_scheme = "Comment",
				})
			end,
		})

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

		use({
			"nvim-telescope/telescope.nvim",
			requires = { { "nvim-lua/plenary.nvim" } },
			config = function()
				local trouble = require("trouble.providers.telescope")
				local actions = require("telescope.actions")
				local actions_file_browser = require("telescope").extensions.file_browser.actions

				require("telescope").setup({
					defaults = {
						layout_strategy = "vertical",
						layout_config = { height = 0.95 },
						mappings = {
							i = {
								["<Esc>"] = actions.close,
								["<C-T>"] = trouble.open_with_trouble,
							},
							n = { ["<C-T>"] = trouble.open_with_trouble },
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
						-- ...
					},
				})

				vim.keymap.set("n", "<C-P><C-P>", function()
					require("telescope.builtin").find_files({ hidden = true })
				end, { silent = true })

				vim.keymap.set("n", "<C-P><C-G>", function()
					require("telescope.builtin").live_grep()
				end, { silent = true })

				vim.keymap.set("n", "<C-P><C-A>", function()
					require("telescope.builtin").grep_string({
						only_sort_text = true,
						search = "",
					})
				end, { silent = true })

				vim.keymap.set("n", "<C-P><C-L>", function()
					require("telescope.builtin").lsp_dynamic_workspace_symbols()
				end, { silent = true })

				vim.keymap.set("n", "<C-P><C-T>", function()
					require("telescope.builtin").grep_string()
				end, { silent = true })

				vim.keymap.set("n", "<C-P><C-F>", function()
					require("telescope").extensions.file_browser.file_browser({ path = "%:p:h" })
				end, { silent = true })

				vim.keymap.set("n", "gd", function()
					require("telescope.builtin").lsp_definitions()
				end, { silent = true })

				vim.keymap.set("n", "gi", function()
					require("telescope.builtin").lsp_implementations()
				end, { silent = true })

				vim.keymap.set("n", "gD", function()
					require("telescope.builtin").lsp_type_definitions()
				end, { silent = true })

				vim.keymap.set("n", "gr", function()
					require("telescope.builtin").lsp_references()
				end, { silent = true })
			end,
		})

		use({
			"hrsh7th/nvim-cmp",
			config = function()
				local cmp = require("cmp")
				local has_words_before = function()
					local line, col = unpack(vim.api.nvim_win_get_cursor(0))
					return col ~= 0
						and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
				end

				local luasnip = require("luasnip")

				cmp.setup({
					snippet = {
						-- REQUIRED - you must specify a snippet engine
						expand = function(args)
							require("luasnip").lsp_expand(args.body)
						end,
					},

					window = {
						-- completion = cmp.config.window.bordered(),
						-- documentation = cmp.config.window.bordered(),
					},

					mapping = {
						-- ["<C-B>"] = cmp.mapping.scroll_docs(-4),
						-- ["<C-F>"] = cmp.mapping.scroll_docs(4),
						-- ["<C-P>"] = cmp.mapping.complete(),

						["<C-E>"] = cmp.mapping(function()
							if luasnip.choice_active() then
								luasnip.change_choice(1)
							else
								cmp.mapping.abort()
							end
						end),

						["<CR>"] = cmp.mapping.confirm({ select = true }),

						["<Tab>"] = cmp.mapping(function(fallback)
							if luasnip.expandable() then
								luasnip.expand()
							elseif has_words_before() then
								cmp.complete()
							else
								fallback()
							end
						end, { "i", "s" }),

						["<C-F>"] = cmp.mapping(function(fallback)
							if luasnip.jumpable() then
								luasnip.jump(1)
							elseif has_words_before() then
								cmp.complete()
							else
								fallback()
							end
						end, { "i", "s" }),

						["<C-O>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							else
								fallback()
							end
						end, { "i", "s" }),

						["<C-P>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							else
								fallback()
							end
						end, { "i", "s" }),
					},
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "luasnip" }, -- For luasnip users.
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

				-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
				cmp.setup.cmdline("/", {
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
				})
			end,
		})

		use("hrsh7th/cmp-nvim-lsp")

		use("saadparwaiz1/cmp_luasnip")

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
					Redo = "Redo",
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
                })
				do
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

		use({
			"pwntester/octo.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope.nvim",
				"kyazdani42/nvim-web-devicons",
			},
			config = function()
				require("octo").setup({
					github_hostname = "github.com",
					reaction_viewer_hint_icon = " •",
				})
			end,
		})

		use({
			"folke/which-key.nvim",
			config = function()
				require("which-key").setup({
					-- your configuration comes here
					-- or leave it empty to use the default settings
					-- refer to the configuration section below
				})
			end,
		})

		use({
			"jose-elias-alvarez/nvim-lsp-ts-utils",
		})
	end,
	config = {
		display = {
			working_sym = "•",
		},
	},
})
