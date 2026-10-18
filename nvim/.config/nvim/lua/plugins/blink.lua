return {
	{
		'saghen/blink.cmp',
		lazy = false,
		-- optional: provides snippets for the snippet source
		dependencies = { 'rafamadriz/friendly-snippets' },

		-- use a release tag to download pre-built binaries
		version = '1.*',
		-- AND/OR build from source
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				preset = 'default',
				["<S-Tab>"] = { 'select_prev', 'fallback' },
				["<Tab>"] = { 'select_next', 'fallback' },
				["<C-k>"] = { 'select_prev', 'fallback' },
				["<C-j>"] = { 'select_next', 'fallback' },
				["<C-k>"] = { 'select_prev', 'fallback' },
				["<CR>"] = { 'accept', 'fallback' },
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = 'mono'
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = { documentation = { auto_show = false } },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },

				-- Providers block was written by AI.
				-- Fix <T>
				providers = {
					lsp = {
						transform_items = function(_, items)
							local Kind = require('blink.cmp.types').CompletionItemKind
							for _, item in ipairs(items) do
								if item.kind == Kind.Method or item.kind == Kind.Function then
									local label = item.label or ''
									local detail = item.detail or ''
									local base_name = (item.insertText or label):match('^([%w_]+)')

									-- Matches Roslyn's "GetState<>" label or csharp_ls's "<T>" detail
									if base_name and (label:find('<.*>') or detail:find('<.*>')) then
										local snippet_text = base_name .. '<$1>($2)$0'
										item.insertTextFormat = 2 -- 2 = Snippet
										item.insertText = snippet_text
										item.kind = Kind.Snippet -- Prevents blink's auto_brackets from forcing ()
										if item.textEdit then
											item.textEdit.newText = snippet_text
										end
									end
								end
							end
							return items
						end,
					},
				},
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" }
		},
		opts_extend = { "sources.default" }
	},
	{
		'saghen/blink.pairs',
		dependencies = 'saghen/blink.lib',

		version = '*',
		-- download prebuilt binaries from github releases, must be on a versioned release
		build = function() require('blink.pairs').download():pwait(60000) end,
		-- OR build from source
		-- build = function() require('blink.pairs').build():pwait(60000) end,

		--- @module 'blink.pairs'
		--- @type blink.pairs.Config
		opts = {},
	},
}
