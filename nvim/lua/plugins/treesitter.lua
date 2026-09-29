return {
	{
	  "nvim-treesitter/nvim-treesitter",
	  build = ":TSUpdate",
	  config = function()
		local ok, ts = pcall(require, "nvim-treesitter.configs")
		if not ok then return end
		ts.setup({
		  ensure_installed = { "clandg", "rust", "lua", "toml", "bash", "java" },
		  highlight = { enable = true },
		  indent = { enable = true },
		  incremental_selection = { enable = true },
		  textobjects = { enable = true },
		})
	  end,
  }
}
