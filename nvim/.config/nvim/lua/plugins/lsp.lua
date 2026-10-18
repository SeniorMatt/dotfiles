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
		lazy = false,
    keys = {
			{'<F2>', function() vim.lsp.buf.rename() end },
			{'<F3>', function() vim.lsp.buf.format() end },
			{'gd', function() vim.lsp.buf.definition() end },
    },
		opts = {
			ensure_installed = { "lua_ls", "csharp_ls", "qmlls", "clangd" },
		},
	},
}
