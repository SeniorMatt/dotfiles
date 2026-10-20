vim.opt.number = true;
vim.opt.relativenumber = true;
vim.opt.shiftwidth = 4;
vim.opt.tabstop = 4;

-- Set a colorcolumn at max line length
vim.opt.colorcolumn = "+1"

-- Diagnostics
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		border = 'rounded',
		source = true,
	},
})

-- Change the colorscheme
vim.cmd("colorscheme gruvbox");
