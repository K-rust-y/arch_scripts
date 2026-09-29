require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "rust_analyzer", "clangd", "jdtls" }
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.semanticTokens = nil

local lspconfig = require("lspconfig")

-- Rust
lspconfig.rust_analyzer.setup({
	 on_attach = function(client, bufnr)
    -- rustfmt on save
    if client.name == "rust_analyzer" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            timeout_ms = 2000,
            filter = function(c)
              return c.name == "rust_analyzer"
            end
          })
        end
      })
    end
  end,
  settings = {
    ["rust-analyzer"] = {
      cargo = { 
		  allFeatures = false, 
		  loadOutDirsFromCheck = false, 
		  buildSCripts = { enable = false }
		},
      checkOnSave = true,
      check = {
				enable = true,
				command = 'clippy',
				features = 'all',
				extraArgs= {"--no-deps"}
      },
    }
}
})

-- C / C++
lspconfig.clangd.setup({
  cmd = { "clangd", "--background-index" }
})
