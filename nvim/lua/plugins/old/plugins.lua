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
-- LSP
{ "neovim/nvim-lspconfig" },
--{ "williamboman/mason.nvim", config = true },
--{ "williamboman/mason-lspconfig.nvim" },

-- Completion
{ "hrsh7th/nvim-cmp" },
{ "hrsh7th/cmp-nvim-lsp" },
{ "L3MON4D3/LuaSnip" },

-- Treesitter
{
"nvim-treesitter/nvim-treesitter",
build = ":TSUpdate",
config = function()
  local ok, ts = pcall(require, "nvim-treesitter.configs")
  if not ok then return end
  ts.setup({
    ensure_installed = { "rust", "lua", "toml", "bash", "java" },
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = { enable = true },
    textobjects = { enable = true },
  })
end,
},

-- Telescope
{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

-- Symbol outline
{ "simrat39/symbols-outline.nvim" },

-- UI
{ "nvim-lualine/lualine.nvim" },

--- Nerdtree like

{
 "nvim-neo-tree/neo-tree.nvim",
 branch = "v3.x",
 dependencies = {
   "nvim-lua/plenary.nvim",
   "nvim-tree/nvim-web-devicons",
   "MunifTanjim/nui.nvim",
},
config = function()
  require("neo-tree").setup({
    close_if_last_window = true,
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      hijack_netrw_behavior = "open_default",
    },
    window = {
      width = 30,
    },
	default_component_configs = {
        icon = {
          folder_closed = "[+]",
          folder_open   = "[-]",
          folder_empty  = "[ ]",
          default       = "F",
        },
       name = {
          trailing_slash = false,
        },	
},
    })
  end,
}
})
