----- Plugin manager lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone",
		"https://github.com/folke/lazy.nvim.git",
		lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	require("plugins.treesitter"),
	require("plugins.neotree"),
	require("plugins.telescope"),
	require("plugins.lsp"),
	require("plugins.cmp")
})
