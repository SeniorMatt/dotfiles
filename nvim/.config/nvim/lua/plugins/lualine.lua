return {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = function()
			local custom_gruvbox = require 'lualine.themes.gruvbox'

			require('lualine').setup {
				options = { theme = custom_gruvbox },
			}
		end
	},
}
