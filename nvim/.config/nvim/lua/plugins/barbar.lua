--- Plugin for Tabs
return {
	{
		'romgrk/barbar.nvim',
		dependencies = {
			'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
			'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
		},
		init = function() vim.g.barbar_auto_setup = false end,
		opts = {
			-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
			-- animation = true,
			-- insert_at_start = true,
			-- …etc.
			animation = false,
			sidebar_filetypes = {
				-- Use the default values: {event = 'BufWinLeave', text = '', align = 'left'}
				-- NvimTree = true,
				-- ['neo-tree'] = {event = 'BufWipeout'},
			},
		},
		lazy = false,
		keys = {
			{ "<leader>x", "<cmd>BufferClose<cr>" },
			{ "H",         "<cmd>BufferPrevious<cr>" },
			{ "L",         "<cmd>BufferNext<cr>" },
			{ "<leader>h", "<cmd>BufferMovePrevious<cr>" },
			{ "<leader>l", "<cmd>BufferMoveNext<cr>" },
		},
		version = '^1.0.0', -- optional: only update when a new 1.x version is released
	},
}
