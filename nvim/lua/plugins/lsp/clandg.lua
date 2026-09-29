return {
  cmd = {
    "clangd",
    "--background-index",        -- index project in background
    "--clang-tidy",              -- enable clang-tidy diagnostics
    "--header-insertion=iwyu",   -- include-what-you-use style
    "--completion-style=detailed",
    "--fallback-style=llvm",     -- formatting fallback
  },
  root_markers = { '.clangd', 'compile_commands.json', 'Makefile' },
  filetypes = { 'c', 'cpp' },
}

