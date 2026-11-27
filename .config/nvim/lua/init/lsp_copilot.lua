local wrap_filetypes = {
	gitcommit = true,
	markdown = true,
	text = true,
}

-- wrap inline completion (copilot) text to textwidth for text/markdown files
-- see https://github.com/neovim/neovim/issues/42841
-- see https://github.com/neovim/neovim/issues/41369
local function wrap_text(str, width)
	local regex_space = vim.regex("^.*\\%<" .. tostring(width + 2) .. "v\\zs ")
	local regex_width = vim.regex("\\%" .. tostring(width + 1) .. "v")

	local function wrap_text_line(line)
		local wrapped = {}
		while vim.fn.strdisplaywidth(line) > width do
			local space_start, space_end = regex_space:match_str(line)
			if not space_start then
				-- no space found, find byte for virtual column width+1 and wrap there
				space_start, space_end = regex_width:match_str(line)
				if not space_start then
					-- fallback to width as a last resort
					space_start, space_end = width, width
				end
			end

			table.insert(wrapped, line:sub(1, space_start))
			line = line:sub(space_end + 1)
		end
		if #line > 0 then
			table.insert(wrapped, line)
		end
		return table.concat(wrapped, "\n")
	end

	return vim.iter(vim.gsplit(str, "\n", { plain = true })):map(wrap_text_line):join("\n")
end

require('vim.lsp.inline_completion')
---@diagnostic disable-next-line: inject-field
require('vim.lsp._capability').all.inline_completion.handler = (function(orig)
	return function(self, ...)
		local err, result, ctx = ...
		if not err and result and ctx then
			local ft = vim.bo[ctx.bufnr].filetype
			local tw = vim.bo[ctx.bufnr].textwidth
			if tw > 0 and wrap_filetypes[ft] then
				local items = result.items or result
				for _, item in ipairs(items) do
					if item.insertText then
						item.insertText = wrap_text(item.insertText, tw)
					end
				end
			end
		end

		return orig(self, ...)
	end
---@diagnostic disable-next-line: undefined-field
end)(require('vim.lsp._capability').all.inline_completion.handler)

local function longest_common_prefix(s1, s2)
	local prefix = 0
	while prefix < #s1 and prefix < #s2 and s1[prefix + 1] == s2[prefix + 1] do
		prefix = prefix + 1
	end
	return s1:sub(1, prefix)
end

local function on_accept_word(item)
	if type(item.insert_text) == "string" and item.range then
		local current_lines = vim.api.nvim_buf_get_text(
			item.range.buf,
			item.range.start_row,
			item.range.start_col,
			item.range.end_row,
			item.range.end_col,
			{}
		)

		-- XXX: vim.lsp._changetracking sends the correct line endings for the
		-- buffer to the LSP, but vim.lsp.inline_completion uses \n everywhere
		-- regardless - for good reason probably, as copilot-language-server
		-- seems to always use \n anyway
		local current_text = table.concat(current_lines, '\n')

		local prefix = longest_common_prefix(current_text, item.insert_text)
		local new_text = item.insert_text:sub(#prefix + 1)
		local word = string.match(new_text, "%s*[^%s]+%s?")
		if word then
			item.insert_text = prefix .. word
		end
	end

	return item
end

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client.name == "copilot" and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, args.buf) then
			vim.lsp.inline_completion.enable(true, { bufnr = args.buf })

			vim.keymap.set('i', '<C-Space>', vim.lsp.inline_completion.get, {
				buffer = args.buf,
				desc = "LSP: accept inline completion",
			})
			vim.keymap.set('i', '<C-X><C-Space>', function()
				vim.lsp.inline_completion.get({ on_accept = on_accept_word })
			end, {
				buffer = args.buf,
				desc = "LSP: accept inline completion",
			})
			vim.keymap.set('i', '<C-X>]', function() vim.lsp.inline_completion.select({ count = 1 }) end, {
				buffer = args.buf,
				desc = "LSP: next inline completion",
			})
			vim.keymap.set('i', '<C-X>[', function() vim.lsp.inline_completion.select({ count = -1 }) end, {
				buffer = args.buf,
				desc = "LSP: prev inline completion",
			})
		end
	end,
})
