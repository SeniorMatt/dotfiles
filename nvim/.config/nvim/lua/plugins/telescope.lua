-- Plugin for quick file / directories switch
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
		config = function(_, opts)
			require('telescope').setup(opts);
			require('telescope').load_extension('projects')
			require('telescope').load_extension('fzf')
		end,
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
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case", -- "Multi" matches case-sensitively, "multi" matches everything
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
			{ "<leader>fp", "<cmd>Telescope projects<cr>" },
			{ "<leader>fr", function() require("telescope.builtin").lsp_references() end },
			-- Code action
			{ "<leader>ca", function() vim.lsp.buf.code_action() end,                    mode = { "n", "v" } },
		},
	},
}
