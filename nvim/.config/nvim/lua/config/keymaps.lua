-- Map movement
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

local modes = { "i", "c" }
vim.keymap.set(modes, "<C-h>", "<Left>")
vim.keymap.set(modes, "<C-j>", "<Down>")
vim.keymap.set(modes, "<C-k>", "<Up>")
vim.keymap.set(modes, "<C-l>", "<Right>")

-- Map Ctrl+C to behave like Esc
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Space Y copies in to the clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { noremap = true, silent = true })
