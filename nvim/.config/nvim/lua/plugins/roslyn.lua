-- C# language server
return {
	{
		"seblyng/roslyn.nvim",
		ft = "cs",
		opts = {
			filewatching = "roslyn", -- server watches files itself; try "off" if still slow
			lock_target = true,      -- don't re-pick the .sln on every file open
		},
		config = function(_, opts)
			vim.lsp.config("roslyn", {
				cmd_env = {
					DOTNET_ROOT = "/usr/share/dotnet",
					DOTNET_gcServer = "0", -- workstation GC: less RAM, fewer stalls
				},
				settings = {
					["csharp|completion"] = {
						dotnet_show_completion_items_from_unimported_namespaces = true,
						dotnet_show_name_completion_suggestions = true,
					},
					["csharp|background_analysis"] = {
						dotnet_analyzer_diagnostics_scope = "openFiles", -- or "none" for max speed
						dotnet_compiler_diagnostics_scope = "openFiles",
					},
				},
			})
			require("roslyn").setup(opts)
		end,
	},
}
