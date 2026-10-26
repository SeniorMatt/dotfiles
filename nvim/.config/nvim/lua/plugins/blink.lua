-- Written by AI. But works exactly the way I want it to.

-- Completion helpers:
--   Enter on a C# method   → Name(|)       (no brackets after += / -= / nameof( / Callable.From( )
--   Enter on a C# generic  → Name<|>()
--   ( or < with a C# suggestion highlighted accepts it and opens the brackets
--   Typing an opening bracket right before the same bracket steps over it:
--     Name|()  + (  → Name(|)
--     |{ }     + {  → {| }
--     |[]      + [  → [|]
--     |<T>     + <  → <|T>    (only when it looks like a generic, not a comparison)
--   > steps over an existing > that closes a generic, e.g. List<int|> → List<int>|

local function feed(keys)
	vim.api.nvim_feedkeys(vim.keycode(keys), 'n', false)
end

-- Filetypes where "<" starts a tag, so angle-bracket stepping is off
local MARKUP = {
	html = true, xml = true, vue = true, svelte = true, astro = true,
	javascriptreact = true, typescriptreact = true, markdown = true,
}

-- What can sit between generic angle brackets: Dictionary<string, List<int>?>
-- Comparisons almost always contain other characters (&&, ||, ;, parentheses, ...)
local GENERIC_INNER = '[%w_%.,%s%[%]%?<>]*'

-- Cursor is right before a "<...>" that looks like a generic
local function generic_opens_here()
	if MARKUP[vim.bo.filetype] then return false end
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local after = vim.api.nvim_get_current_line():sub(col + 1)
	return after:match('^<' .. GENERIC_INNER .. '>') ~= nil
end

-- Cursor is right before a ">" that closes a generic
local function before_closing_gt()
	if MARKUP[vim.bo.filetype] then return false end
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local line = vim.api.nvim_get_current_line()
	return line:sub(col + 1, col + 1) == '>' and line:sub(1, col):match('<' .. GENERIC_INNER .. '$') ~= nil
end

local function cs_item(cmp, kinds)
	if vim.bo.filetype ~= 'cs' or not cmp.is_visible() then return nil end
	local item = cmp.get_selected_item()
	if not item or item.source_id ~= 'lsp' then return nil end
	local K = require('blink.cmp.types').CompletionItemKind
	for _, name in ipairs(kinds) do
		if item.kind == K[name] then return item end
	end
end

local function is_method(item)
	local K = require('blink.cmp.types').CompletionItemKind
	return item.kind == K.Method or item.kind == K.Function
end

-- Roslyn labels generics "GetNode<>"; csharp_ls puts "GetNode<T>(...)" in detail
local function is_generic(item)
	local label = item.label or ''
	local name = label:match('^[%w_]+') or label
	local function has(s) return type(s) == 'string' and s:find(name .. '<', 1, true) ~= nil end
	return label:find('<', 1, true) ~= nil
		or has(item.detail)
		or has(item.labelDetails and item.labelDetails.detail)
end

-- If the next character is `char`, move past it and return true.
-- Blink keymaps are <expr> mappings, which restore the cursor afterwards,
-- so the move has to be scheduled to run after the mapping finishes.
local function step_over(char)
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	if vim.api.nvim_get_current_line():sub(col + 1, col + 1) ~= char then return false end
	vim.schedule(function() vim.api.nvim_win_set_cursor(0, { row, col + 1 }) end)
	return true
end

local function show_signature()
	vim.schedule(function() pcall(require('blink.cmp').show_signature) end)
end

-- "(" : step into an existing "(", otherwise insert "()"
local function open_parens()
	if step_over('(') then
		show_signature()
	else
		feed('()<Left>')
	end
end

local function add_brackets(generic)
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local line = vim.api.nvim_get_current_line()
	local before = line:sub(1, col):gsub('[%w_]*$', '')
	local after = line:sub(col + 1)
	if after:match('^[%(<]')                     -- brackets already there
		or before:match('[%+%-]=%s*$')            -- Event += Handler
		or before:match('nameof%(%s*$')           -- nameof(Method)
		or before:match('Callable%.From%(%s*$')   -- Callable.From(Method)
	then
		return
	end
	if generic then
		feed('<lt>>()<Left><Left><Left>')
	else
		feed('()<Left>')
	end
end

-- csharp_ls only sends the full signature (with <T>) on resolve, so ask for it
local function with_resolved(item, cb)
	if is_generic(item) or not item.client_id then return cb(item) end
	local client = vim.lsp.get_client_by_id(item.client_id)
	if not client then return cb(item) end
	local params = {
		label = item.label, kind = item.kind, detail = item.detail, data = item.data,
		insertText = item.insertText, textEdit = item.textEdit,
		filterText = item.filterText, sortText = item.sortText,
	}
	client:request('completionItem/resolve', params, function(_, result)
		vim.schedule(function() cb(result or item) end)
	end)
end

return {
	-- Plugin for completion
	{
		'saghen/blink.cmp',
		lazy = false,
		dependencies = { 'rafamadriz/friendly-snippets' },
		version = '1.*',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = 'default',
				["<Tab>"]   = { 'select_next', 'snippet_forward', 'fallback' },
				["<S-Tab>"] = { 'select_prev', 'snippet_backward', 'fallback' },
				["<C-j>"]   = { 'select_next', 'fallback' },
				["<C-k>"]   = { 'select_prev', 'fallback' },

				["<CR>"] = {
					function(cmp)
						local item = cs_item(cmp, { 'Method', 'Function' })
						if not item then return end -- not a C# method: normal accept
						cmp.accept({
							callback = function()
								local pos = vim.api.nvim_win_get_cursor(0)
								with_resolved(item, function(full)
									-- skip if you already kept typing or left insert mode
									local now = vim.api.nvim_win_get_cursor(0)
									if now[1] == pos[1] and now[2] == pos[2] and vim.fn.mode() == 'i' then
										add_brackets(is_generic(full))
									end
								end)
							end,
						})
						return true
					end,
					'accept',
					'fallback',
				},

				["("] = {
					function(cmp)
						if cs_item(cmp, { 'Method', 'Function', 'Constructor', 'Class', 'Struct' }) then
							cmp.accept({ callback = open_parens })
							return true
						end
						if step_over('(') then
							show_signature()
							return true
						end
					end,
					'fallback',
				},

				["{"] = { function() return step_over('{') or nil end, 'fallback' },
				["["] = { function() return step_over('[') or nil end, 'fallback' },

				["<lt>"] = {
					function(cmp)
						-- C#: accept the highlighted suggestion and open the brackets
						local item = cs_item(cmp, { 'Method', 'Function', 'Class', 'Struct', 'Interface' })
						if item then
							cmp.accept({
								callback = function()
									if generic_opens_here() and step_over('<') then return end
									if is_method(item) then
										feed('<lt>>()<Left><Left><Left>') -- GetNode<|>()
									else
										feed('<lt>><Left>')               -- List<|>
									end
								end,
							})
							return true
						end
						-- Any language: step into an existing generic "<...>"
						if generic_opens_here() then
							return step_over('<') or nil
						end
					end,
					'fallback',
				},

				[">"] = {
					function(cmp)
						if not before_closing_gt() then return end
						if cmp.is_visible() and cmp.get_selected_item() then
							cmp.accept({ callback = function() step_over('>') end })
						else
							step_over('>')
						end
						return true
					end,
					'fallback',
				},
			},

			appearance = { nerd_font_variant = 'mono' },

			completion = {
				accept = { auto_brackets = { enabled = false } }, -- brackets come from the keymaps above
				documentation = { auto_show = true, auto_show_delay_ms = 300 },
			},
			signature = { enabled = true },

			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	-- Plugin for automatic brackets
	{
		'saghen/blink.pairs',
		dependencies = 'saghen/blink.lib',
		version = '*',
		build = function() require('blink.pairs').download():pwait(60000) end,
		opts = {},
	},
}
