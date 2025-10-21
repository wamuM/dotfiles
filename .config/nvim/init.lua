-- Basic Neovim settings
vim.opt.number = true          -- Show absolute line numbers
vim.opt.relativenumber = true  -- Show relative line numbers
vim.opt.wrap = false           -- Disable line wrapping

-- Visual guide for long lines
vim.opt.list = true
vim.opt.listchars:append({ extends = "»", precedes = "«" })

