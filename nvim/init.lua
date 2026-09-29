-- Example: https://github.com/scottmckendry/nix/blob/0fc0b9ce9f87283c35c261af74bfd222ef5886f8/nvim/lua/plugins/lualine.lua
-- Show I go for LazyVim?
-- colorscheme: see nordic

-- Classic Vim cursor behavior in Neovim
local set = vim.opt -- shorthand
vim.g.mapleader = " "
-- General settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.clipboard = "unnamedplus"
vim.o.termguicolors = true
vim.o.updatetime = 200
vim.o.signcolumn = "yes"
vim.o.splitright = false
vim.o.splitbelow = true
vim.opt.termguicolors = true
vim.cmd [[colorscheme darkblue]]
vim.api.nvim_set_hl(0, "MatchParen", {
	bold = true,
	underline = true,
	fg = "red",
	cterm = { bold = true, underline = true }
})

require("plugins")
require("options.keymaps")
require("options.autocmds")
---- Diagnostics
vim.diagnostic.config({
	virtual_text = false, -- cleaner
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})
----- Format on save
vim.g.rustfmt_autosave = 0

---- Shindan specifics
require('plugins.br_section').setup {
	statusline = true,  -- show section in statusline
	virtual_text = false -- set true if you want inline virtual text
}


-- Optional: disable extra cursor highlighting that can feel weird
vim.o.cursorline = false
set.cursorcolumn = false
-- Prevent cursor from moving past end of line
set.virtualedit = ""
-- Jump commands keep cursor in the same column
set.startofline = false
-- Cursor wraps across lines like Vim
set.whichwrap = "<,>,h,l"
-- Others
set.tabstop = 2
set.shiftwidth = 2
set.number = true
set.relativenumber = false
--set.showmatch = true
set.mouse = "v"
