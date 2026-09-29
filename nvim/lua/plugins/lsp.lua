return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local mason = require("mason")
			mason.setup()

			local mason_lsp = require("mason-lspconfig")
			mason_lsp.setup({
				ensure_installed = { "rust_analyzer", "clangd", "pyright", "jdtls", "lua_ls" },
				automatic_installation = true,
			})

			-- keymaps
			vim.keymap.set("n", "gd", vim.lsp.buf.definition)
			vim.keymap.set("n", "K", vim.lsp.buf.hover)
			vim.keymap.set("n", "gr", vim.lsp.buf.references)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

			require("plugins.lsp.rust_analyser")
		end
	},
}
