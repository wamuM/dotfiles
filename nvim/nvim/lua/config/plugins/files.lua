return {
    {'nvim-mini/mini.files', version = false,
    config=function() 
        require("mini.files").setup()

        vim.keymap.set("n","<leader>f",function()
            if not MiniFiles.close() then MiniFiles.open() end
        end)
    end,
    },
}
