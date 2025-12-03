-- Set <leader> to " "
vim.g.mapleader = " "

require("config.lazy")

--  Long Lines
vim.opt.wrap = false           -- Disable line wrapping
vim.opt.list = true
vim.opt.listchars:append({ extends = "»", precedes = "«" })

-- Line numbers
vim.opt.number = true          -- Show absolute line numbers
vim.opt.relativenumber = true  -- Show relative line numbers

-- tabs
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

-- Clipboard
vim.opt.clipboard = "unnamedplus"


-- Remove highlighting if escaping in normalmode 
vim.keymap.set("n", "<esc>", function() vim.cmd('nohlsearch') end, { noremap=true, silent = true })

