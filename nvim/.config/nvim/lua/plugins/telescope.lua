return {
	{
		'nvim-telescope/telescope.nvim',
		version = '*',
		lazy = false,
		dependencies = {
			'nvim-lua/plenary.nvim',
			-- optional but recommended
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		},
		opts = {
			defaults = {
				mappings = {
					i = {
						["<C-j>"] = "move_selection_next",
						["<C-k>"] = "move_selection_previous",
					},
				},
				file_ignore_patterns = {
					"%.uid",
				},
			},
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		},
		keys = {
			{ '<leader>ff', function() require('telescope.builtin').find_files() end },
			{
				"<leader>fd",
				function()
					require("telescope.builtin").find_files({
						prompt_title = "Find Directories",
						find_command = { "fd", "--type", "d", "--max-depth", "6", "--follow" },
					})
				end,
			},
		},
	},
}
