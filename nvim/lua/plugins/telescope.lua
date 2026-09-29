return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
	config = function()
		require("telescope").setup({
			defaults = {
				file_ignore_patterns = {
					".git/",
					"target/",
					"build/",
					"node_modules/",
					".cache/",
					".gradle/"
				},
				layout_config = { prompt_position = "top" },
				theme = "dropdown",
			},
			pickers = {
				find_files = {
					--previewer = false,
					find_command = {
						"fd",
						"--type",
						"f",
						"--strip-cwd-prefix",
						"--exclude",
						".git",
						"--exclude",
						"target",
						"--exclude",
						"build",
						"--exclude",
						".gradle",
						"--exclude",
						"out"
					}
				},
				buffers = { sort_lastused = true },
				live_grep = { only_sort_text = true },
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					}
				},
			}
		})
		require("telescope").load_extension("fzf")
	end,
}
