vim.opt.number = true;
vim.opt.relativenumber = true;
vim.opt.shiftwidth = 2;
vim.opt.tabstop = 2;

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
