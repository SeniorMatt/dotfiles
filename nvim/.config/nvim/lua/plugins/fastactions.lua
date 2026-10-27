return {
	{
		'Chaitanyabsprip/fastaction.nvim',
		---@type FastActionConfig
		opts = {
			dismiss_keys = { "j", "k", "<c-c>", "q" },
			override_function = function(_) end,
			keys = "qwertyuiopasdfghlzxcvbnm",
			popup = {
				border = "rounded",
				hide_cursor = true,
				highlight = {
					action = "MoreMsg",
					divider = "FloatBorder",
					key = "MoreMsg",
					source = "Comment",
					title = "Title",
					window = "NormalFloat",
				},
				title = "Select one of:",
			},
			priority = {
				cs = {
					{ pattern = "generate method", key = "g", order = 1 },
				},
				-- dart = {
				--   { pattern = "organize import", key ="o", order = 1 },
				--   { pattern = "extract method", key ="x", order = 2 },
				--   { pattern = "extract widget", key ="e", order = 3 },
				-- },
			},
			register_ui_select = false,
			format_right_section = nil
		},
		config = function(_, opts)
			require("fastaction").setup(opts)
			vim.keymap.set(
				{ 'n', 'x' },
				'<leader>a',
				'<cmd>lua require("fastaction").code_action()<CR>',
				{ desc = "Display code actions", buffer = bufnr }
			)
			vim.keymap.set(
				{ 'n', 'x' },
				'<leader>f',
				'<cmd>lua require("fastaction").code_action({ select_first = true })<CR>',
				{ desc = "Select and apply first code action", buffer = bufnr }
			)
		end
	},
}
