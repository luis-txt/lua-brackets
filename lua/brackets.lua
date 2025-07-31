local bracket_utils = require('bracket-utils')
local opts = {noremap=true, silent=true}

-- Openers
vim.keymap.set('i', '(', function() bracket_utils.handle_open_bracket('(') end, opts)
vim.keymap.set('i', '[', function() bracket_utils.handle_open_bracket('[') end, opts)
vim.keymap.set('i', '{', function() bracket_utils.handle_open_bracket('{') end, opts)

-- Closers
vim.keymap.set('i', ')', function() bracket_utils.handle_close_bracket(')') end, opts)
vim.keymap.set('i', ']', function() bracket_utils.handle_close_bracket(']') end, opts)
vim.keymap.set('i', '}', function() bracket_utils.handle_close_bracket('}') end, opts)

-- Quotes
vim.keymap.set('i', '"', function() bracket_utils.handle_quotes('"') end, opts)
vim.keymap.set('i', "'", function() bracket_utils.handle_quotes("'") end, opts)

-- Backspace and Enter
vim.keymap.set('i', '<BS>', bracket_utils.remove_matching_bracket, opts)
vim.keymap.set('i', '<CR>', bracket_utils.space_enter, opts)

-- Right arrow skips any closer
vim.keymap.set('i', '<Right>', bracket_utils.close_pair, opts)
