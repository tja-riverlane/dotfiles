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
			if tw > 0 and (ft == "text" or ft == "markdown") then
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

local function on_accept_word(item)
	if type(item.insert_text) == "string" and item.range then
		local insert_lines = vim.split(item.insert_text, "\n", { plain = true })
		local current_lines = vim.api.nvim_buf_get_text(
			item.range.buf,
			item.range.start_row,
			item.range.start_col,
			item.range.end_row,
			item.range.end_col,
			{}
		)

		local row = 1
		while row <= #insert_lines and row <= #current_lines and insert_lines[row] == current_lines[row] do
			row = row + 1
		end

		local col = 1
		if row <= #insert_lines and row <= #current_lines then
			while col <= #insert_lines[row] and col <= #current_lines[row] and insert_lines[row][col] == current_lines[row][col] do
				col = col + 1
			end
		end

		local word = string.match(insert_lines[row]:sub(col), "%s*[^%s]*")
		item.insert_text = table.concat(vim.list_slice(current_lines, 1, row - 1), "\n")
			.. (row <= #current_lines and "" or "\n")
			.. (row <= #insert_lines and col <= #insert_lines[row] and insert_lines[row]:sub(1, col - 1) or "")
			.. word
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
