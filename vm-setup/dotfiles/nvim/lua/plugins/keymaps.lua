-- Personal keymaps that replace LazyVim defaults.
-- LSP and Telescope keys must be overridden in their plugin specs: LazyVim sets
-- them per buffer on LspAttach / when Telescope loads, which would win over
-- plain vim.keymap.set calls in config/keymaps.lua.

-- Jump to the definition in a new split ("vsplit" or "split")
local function definition_in(split)
  return function()
    vim.lsp.buf.definition({
      on_list = function(options)
        vim.fn.setqflist({}, " ", options)
        vim.cmd(split)
        vim.cmd("cfirst")
      end,
    })
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          -- stylua: ignore
          keys = {
            { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
            { "gvd", definition_in("vsplit"), desc = "Goto Definition (vsplit)", has = "definition" },
            { "ghd", definition_in("split"), desc = "Goto Definition (split)", has = "definition" },
            { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
            { "K", function() return vim.lsp.buf.hover() end, desc = "Hover" },
            { "<leader>rn", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
            -- Formats the visual selection (range formatting)
            { "<leader>f", function() vim.lsp.buf.format() end, mode = "x", desc = "Format Selection", has = "rangeFormatting" },
          },
        },
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    -- stylua: ignore
    keys = {
      {
        "<leader>ff",
        function()
          -- git_files errors outside a git repo: fall back to find_files
          if not pcall(require("telescope.builtin").git_files, { show_untracked = true }) then
            require("telescope.builtin").find_files()
          end
        end,
        desc = "Find Files (git, fallback all)",
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep({
            additional_args = function() return { "--hidden", "--no-ignore-vcs" } end,
          })
        end,
        desc = "Live Grep",
      },
      { "<leader>fr", function() require("telescope.builtin").lsp_references() end, desc = "LSP References" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
      { "<leader>fs", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Document Symbols" },
      { "<leader>fd", function() require("telescope.builtin").lsp_definitions() end, desc = "Goto Definition" },
    },
  },
}
