--- Raccourcis

--- Ntree
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { silent = true })

---- Telescope
---- vertical <C-v>
---- <C-x> → horizontal split
---- <C-t> → open in new tab
--:Telescope find_files cwd=…
vim.keymap.set("n", "<leader>ff", function()
	local ok = pcall(require("telescope.builtin").git_files, { show_untracked = true })
	if not ok then
		require("telescope.builtin").find_files()
	end
end)

vim.keymap.set("n", "<leader>fg", function()
	require("telescope.builtin").live_grep({
		additional_args = function()
			return { "--hidden", "--no-ignore-vcs" }
		end
	})
end, { desc = "Live grep" })

vim.keymap.set("n", "<leader>fr", function()
	require("telescope.builtin").lsp_references({
	})
end, { desc = "Live ref" })

vim.keymap.set("n", "<leader>fb", function()
	require("telescope.builtin").buffers()
end, { desc = "Buffers" })

vim.keymap.set("n", "<leader>fs", function()
	require("telescope.builtin").lsp_document_symbols()
end, { desc = "Document symbols" })

vim.keymap.set("n", "<leader>fd", function()
	require("telescope.builtin").lsp_definitions()
end, { desc = "Go to def" })

--- In current dirs
vim.keymap.set('n', '<leader>wf', ':Telescope find_files search_dirs=["%"]<CR>')
vim.keymap.set('n', '<leader>wg', ':Telescope live_grep search_dirs=["%"]<CR>')

---- AOSP
vim.keymap.set('n', '<leader>af',
	':Telescope find_files search_dirs=["~/Repo/AOSP/frameworks","~/Repo/AOSP/packages"]<CR>')
vim.keymap.set('n', '<leader>ag',
	':Telescope live_grep search_dirs=["~/Repo/AOSP/packages","~/Repo/AOSP/frameworks"]<CR>')

-- In terminal search
vim.keymap.set("n", "<leader>fT", function()
	vim.cmd [[
    belowright new
    setlocal nobuflisted buftype=nofile bufhidden=wipe nowrap noswapfile
    terminal bash -c 'fd --type f --hidden --exclude .git --exclude out --exclude bazel-out | fzf --preview "batcat --style=numbers --color=always {}" --ansi --bind "enter:execute(vim +e {}),ctrl-v:execute(vim +vsplit {}),ctrl-x:execute(vim +split {}),ctrl-t:execute(vim +tabedit {})"'
  ]]
end, { desc = "FD in floating terminal with splits" })

---- Lsp
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gvd", function()
	vim.lsp.buf.definition({
		on_list = function(options)
			vim.fn.setqflist({}, ' ', options)
			vim.cmd("vsplit")
			vim.cmd("cfirst")
		end,
	})
end)

vim.keymap.set("n", "ghd", function()
	vim.lsp.buf.definition({
		on_list = function(options)
			vim.fn.setqflist({}, ' ', options)
			vim.cmd("split")
			vim.cmd("cfirst")
		end,
	})
end)

vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.api.nvim_set_keymap(
	'v',
	'<leader>f',
	":lua vim.lsp.buf.format()",
	{ noremap = true, silent = true }
)
---- Diagnostics
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>dt", function()
	if vim.diagnostic.is_enabled() then
		vim.diagnostic.disable()
	else
		vim.diagnostic.enable()
	end
end)

---- Shinda
vim.keymap.set(
	"n",
	"<leader>br",
	function() require("plugins.br_section").toggle() end,
	{ desc = "Bug report helpder: display section in statusline" }
)
