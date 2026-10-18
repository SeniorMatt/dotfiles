-- Plugin for file manager
return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		lazy = false,                -- neo-tree will lazily load itself
		opts = {
			filesystem = {
				filtered_items = {
					visible = false, -- when true, they will just be displayed differently than normal items
					hide_by_pattern = {
						"*.uid",
					},
				},
			},
		},
		keys = {
			{ "<C-n>", "<cmd>Neotree toggle left<cr>" },
		},
	}
}
