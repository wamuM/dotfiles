--  Long Lines
vim.opt.wrap = false           -- Disable line wrapping
vim.opt.list = true
vim.opt.listchars:append({ extends = "»", precedes = "«" })

-- Line numbers
vim.opt.number = true          -- Show absolute line numbers
vim.opt.relativenumber = true  -- Show relative line numbers


-- Clipboard
vim.opt.clipboard = "unnamedplus"

