return {
	'nvim-treesitter/nvim-treesitter',
	lazy = false,
	build = ':TSUpdate',
	setup = {
		install = {
			'lua', 'c_sharp', 'markdown'
		},
	},
}
