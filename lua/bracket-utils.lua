-- Collection of smart auto-pairing and skipping
local M = {}

local bracket_pairs = {
	['('] = ')', ['['] = ']', ['{'] = '}',
	["\""] = "\"", ["'"] = "'"
}

local function feed_keys_helper(keys)
	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes(keys, true, false, true),
		'n', true
	)
end

function M.skip_close_pair()
	feed_keys_helper('<Right>')
end

function M.handle_open_bracket(char)
	local _, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local next = line:sub(col+1, col+1)
	if bracket_pairs[char] == next then
		-- next is the matching closer, skip
		return M.skip_close_pair()
	end
	if next == '' or next:match('%s') then
		-- whitespace or empty, insert pair
		return feed_keys_helper(char .. bracket_pairs[char] .. '<Left>')
	end
	-- just insert opener
	return feed_keys_helper(char)
end

function M.handle_close_bracket(char)
	local _, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local next = line:sub(col+1, col+1)
	if next == char then
		return M.skip_close_pair()
	else
		return feed_keys_helper(char)
	end
end

function M.handle_quotes(char)
	local _, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local next = line:sub(col+1, col+1)
	if next == char then
		return M.skip_close_pair()
	else
		return feed_keys_helper(char .. char .. '<Left>')
	end
end

-- Backspace: delete empty pair or single
function M.remove_matching_bracket()
	local _, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local prev = line:sub(col, col)
	local next = line:sub(col+1, col+1)
	if bracket_pairs[prev] == next then
		return feed_keys_helper('<BS><Del>') -- delete both
	else
		return feed_keys_helper('<BS>')
	end
end

-- Enter inside pair: newline + indent + newline
function M.space_enter()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = vim.api.nvim_get_current_line()
	local col = cursor[2]
	local prev_char = string.sub(line, col, col)
	local next_char = string.sub(line, col + 1, col + 1)
	local matching_closing = bracket_pairs[prev_char]

	-- cursor is between two matching brackets or quotation marks
	if matching_closing and next_char == matching_closing then
		-- make two enter and the fitting indentation between them
		vim.api.nvim_feedkeys(
			vim.api.nvim_replace_termcodes("<CR><Up><End><CR>", true, false, true),
			"n", true
		)
		return
	end

	-- just insert an enter
	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes("<CR>", true, false, true),
		"n", true
	)
end

return M
