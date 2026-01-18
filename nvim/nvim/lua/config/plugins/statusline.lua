return {
    { 'nvim-mini/mini.statusline', version = false,
     config = function() 
        require("mini.statusline").setup()
        vim.o.showmode = false
     end,
    },
}
