return {
	{
    'nvim-telescope/telescope.nvim', version = '*',
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
			},
		},
		keys = {
			{'<leader>ff', function() require('telescope.builtin').find_files() end },
			{
        "<leader>fd",
        function()
          require("telescope.builtin").find_files({
            prompt_title = "Find Directories",
            find_command = { "fd", "--type", "d", "--follow" },
          })
        end,
      },
		},
	},
}
