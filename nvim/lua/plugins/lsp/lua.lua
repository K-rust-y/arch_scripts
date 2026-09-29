vim.lsp.config.lua.setup({
	on_attach = on_attach,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",     -- Lua version used by Neovim
			},
			diagnostics = {
				globals = { "vim" },     -- recognize `vim` as global
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = { enable = false },     -- disable telemetry
		},
	},
})
