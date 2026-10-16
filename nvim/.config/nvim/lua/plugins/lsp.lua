return {
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			{ "neovim/nvim-lspconfig",
				config = function()
					vim.lsp.config("csharp_ls", {
						cmd_env = { DOTNET_ROOT = "/usr/share/dotnet" },
					})
				end,
			},
		},
		opts = {
			ensure_installed = { "lua_ls", "csharp_ls" },
		},
	},
}
