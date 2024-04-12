return {
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	"tpope/vim-sleuth",

	{
		"mfussenegger/nvim-lint",
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				svelte = { "eslint_d" },
				kotlin = { "ktlint" },
				terraform = { "tflint" },
				ruby = { "standardrb" },
			}

			local eslint = lint.linters.eslint_d

			eslint.args = {
				"--no-warn-ignored", -- <-- this is the key argument
				"--format",
				"json",
				"--stdin",
				"--stdin-filename",
				function()
					return vim.api.nvim_buf_get_name(0)
				end,
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>ll", function()
				lint.try_lint()
			end, { desc = "Trigger linting for current file" })
		end,
	},

	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					svelte = { { "eslint_d", "eslint" } },
					javascript = { { "eslint_d", "eslint" } },
					typescript = { { "eslint_d", "eslint" } },
					javascriptreact = { { "eslint_d", "eslint" } },
					typescriptreact = { { "eslint_d", "eslint" } },
					json = { { "prettierd", "prettier" } },
					graphql = { { "prettierd", "prettier" } },
					java = { "google-java-format" },
					kotlin = { "ktlint" },
					ruby = { "standardrb" },
					markdown = { { "prettierd", "prettier" } },
					erb = { "htmlbeautifier" },
					html = { "htmlbeautifier" },
					bash = { "beautysh" },
					proto = { "buf" },
					rust = { "rustfmt" },
					yaml = { "yamlfix" },
					toml = { "taplo" },
					css = { { "prettierd", "prettier" } },
					scss = { { "prettierd", "prettier" } },
				},
				format_on_save = {
					lsp_fallback = true,
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>f", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				})
			end, { desc = "Format file or range (in visual mode)" })
		end,
	},

	{ "folke/which-key.nvim", opts = {} },

	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				vim.keymap.set(
					"n",
					"<leader>hp",
					require("gitsigns").preview_hunk,
					{ buffer = bufnr, desc = "Preview git hunk" }
				)

				local gs = package.loaded.gitsigns
				vim.keymap.set({ "n", "v" }, "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
				vim.keymap.set({ "n", "v" }, "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
			end,
		},
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
	},

	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("rose-pine")
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = false,
				theme = "auto",
				component_separators = "|",
				section_separators = "",
			},
		},
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},

	{ "numToStr/Comment.nvim", opts = {} },
}
