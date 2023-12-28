local bracket_utils = require('bracket-utils')

-- auto pair
vim.keymap.set('i', '(', function() bracket_utils.handle_open_bracket('(') end)
vim.keymap.set('i', '{', function() bracket_utils.handle_open_bracket('{') end)
vim.keymap.set('i', '[', function() bracket_utils.handle_open_bracket('[') end)

vim.keymap.set('i', '\'', function() bracket_utils.handle_quotes('\'') end)
vim.keymap.set('i', '"', function() bracket_utils.handle_quotes('"') end)
vim.keymap.set('i', '<BS>', function() bracket_utils.remove_matching_bracket() end)
vim.keymap.set('i', '<CR>', function() bracket_utils.space_enter() end)

local chars_to_close = {')', '}', ']'}
for _, char in ipairs(chars_to_close) do
  vim.keymap.set('i', char, function() bracket_utils.close_brackets(char) end)
end
