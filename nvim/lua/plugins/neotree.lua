-- ~/.config/nvim/lua/plugins/neotree.lua
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,
			popup_border_style = "rounded",
			sort_case_insensitive = true, -- good for large projects
			default_component_configs = {
				indent = {
					-- Ultra-clear indentation for large projects
					padding = 2, -- space before the file/folder name
					indent_size = 2, -- width per indent level
					with_markers = true,
					markers = {
						corner = "╰─",
						edge = "│ ",
						item = "├─",
						none = "  ",
					},
				},
				name = {
					trailing_slash = false,
				},
			},
			window = {
				position = "left",
				width = 50, -- wider for long filenames
				mappings = {
					["U"] = "navigate_up",
					["."] = "set_root",
					["H"] = "toggle_hidden",
					["o"] = "open",
					["<CR>"] = "open",
					["Y"] = {
						function(state)
							local node = state.tree:get_node()
							local path = node:get_id()
							vim.fn.setreg("+", path, "y")
						end,
						desc = "Copy Path to Clipboard",
					},
				},
				["P"] = {
					"toggle_preview",
					config = {
						use_float = true,
						use_snacks_image = true,
						use_image_nvim = true,
					},
				},
				["S"] = "open_split",
				["s"] = "open_vsplit",
				["t"] = "open_tabnew",
				["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
				["<"] = "prev_source",
				[">"] = "next_source",
				["i"] = "show_file_details",
			},
			filesystem = {
				follow_current_file = true,
				hijack_netrw_behavior = "open_current",
				use_libuv_file_watcher = true,
			},
			buffers = {
				follow_current_file = true,
			},
		})
	end,
}
--return {
--	{
--	  "nvim-neo-tree/neo-tree.nvim",

--
--	  dependencies = {
--		"nvim-lua/plenary.nvim",
--		"MunifTanjim/nui.nvim",
--	  },
--
--	config = function()
--	  require("neo-tree").setup({
--		close_if_last_window = true,
--		filesystem = {
--		  follow_current_file = {
--			enabled = true,
--		  },
--		  hijack_netrw_behavior = "open_default",
--		},
--		window = {
--		  width = 30,
--		},
--		default_component_configs = {
--			icon = {
--			  folder_closed = "[+]",
--			  folder_open   = "[-]",
--			  folder_empty  = "[ ]",
--			  default       = "F",
--			},
--		   name = {
--			  trailing_slash = false,
--			},	
--		},
--	  })
--	  end,
--}
--}
