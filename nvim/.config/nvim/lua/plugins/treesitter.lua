-- Plugin for highlighting
return {
	'nvim-treesitter/nvim-treesitter',
	lazy = false,
	build = ':TSUpdate',
	opts = {
		ensure_installed = { 'lua', 'c_sharp', 'markdown' },
	},
}
