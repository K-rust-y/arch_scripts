-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- LSP and Telescope keymaps live in lua/plugins/keymaps.lua

---- Buffer tabs (bufferline): gt / gT like Vim tabs, {count}gt jumps to buffer {count}
-- Real tab pages stay on <leader><tab>] and <leader><tab>[
vim.keymap.set("n", "gt", function()
  vim.cmd(vim.v.count > 0 and ("BufferLineGoToBuffer " .. vim.v.count) or "BufferLineCycleNext")
end, { desc = "Next Buffer Tab" })
vim.keymap.set("n", "gT", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer Tab" })

---- Diagnostics
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next Diagnostic" })
vim.keymap.set("n", "<leader>dt", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle Diagnostics" })
