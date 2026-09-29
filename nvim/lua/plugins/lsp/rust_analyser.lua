local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config('rust_analyzer', {
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = false,
				loadOutDirsFromCheck = false,
				buildScripts = { enable = false }
			},
			procMacro = { enable = true },
			checkOnSave = {
				enable = true,
				command = 'clippy',
				features = 'all',
				extraArgs = { "--no-deps" }
			},
		}
	},
})

vim.lsp.enable('rust_analyzer')
