--[[ 
  Collection of additions and simplifications for the use of parentheses
  and quotation marks
--]]
local M = { }

local bracket_pairs = {
  ['('] = ')',
  ['['] = ']',
  ['{'] = '}',
  ['"'] = '"',
  ["'"] = "'",
}

--[[
	Check wether cursor is in front of a whitespace. If so it inserts both opening and closing
	bracket. Else the cursor is in front of text. In that case it just inserts the typed bracket.

	Behavior:
	| and ( is entered => (|)
	|x and ( is entered => (|x
--]]
function M.handle_open_bracket(char)
	local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local col = cursor[2]
  local next_char = string.sub(line, col + 1, col + 1)
	local curr_char = string.sub(line, col, col)

  if next_char == '' or next_char == '\n' or next_char == '\t' or curr_char == '' then
		-- cursor in front of whitespace
		vim.api.nvim_feedkeys(
			vim.api.nvim_replace_termcodes(char .. bracket_pairs[char] .. "<Left>", true, false, true),
			"n", true
		)
	else
		-- cursor in front of text
		vim.api.nvim_feedkeys(
			vim.api.nvim_replace_termcodes(char, true, false, true),
			"n", true
		)
  end
end

--[[ 
  Additional implementation for quotations because they behave different 
  (since the open and closed character is the same)

  Behavior:
  | and " is entered => "|"
  "|" and " is entered => ""|
--]]
function M.handle_quotes(char)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local col = cursor[2]
  local next_char = string.sub(line, col + 1, col + 1)

  -- no already opened quotation marks
  if char ~= next_char then
    -- add two quotation marks and set the cursor between them
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(char .. char .. "<Left>", true, false, true),
      "n", true
    )
  else
    -- move cursor to the right
    M.close_brackets(char)
  end
end

--[[ 
  Remove matching brackets when return between brackets

  Behavior:
  (|) and return is entered => |
--]]
function M.remove_matching_bracket()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local col = cursor[2]
  local char = string.sub(line, col, col)
  local matching_closing = bracket_pairs[char]
  local next_char = string.sub(line, col + 1, col + 1)

  -- cursor is between two matching brackets or quotation marks
  if matching_closing and matching_closing == next_char then
    -- remove the opening and closing bracket or both quotation marks
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<BS><Del>", true, false, true),
      "n", true
    )
    return
  end

  -- remove bracket or quotation mark to the left of the cursor
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<BS>", true, false, true),
    "n", true
  )
end

--[[ 
  Fancy enter in brackets

  Behavior:
  (|) and enter is entered =>
  (
  <<TAB TAB>>
  )
--]]
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
