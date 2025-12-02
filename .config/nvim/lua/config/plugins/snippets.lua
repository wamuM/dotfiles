return {
    {
	"L3MON4D3/LuaSnip", version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	build = "make install_jsregexp",
    lazy = false,
    config = function() 
        local ls = require("luasnip")
        ls.config.setup({
           -- Global variables for the snippets in the snippets folder
           snip_env = {
               __snip_env_behaviour = "extend", -- include the default ones
           },
           -- Allows to jump to the file that defined a snippet
           loaders_store_source = true, 
           update_events= {"TextChanged","TextChangedI"},
        })
        
        -- Load snippets from snippets directory
        require("luasnip.loaders.from_lua").lazy_load({paths = vim.fn.stdpath("config").."/snippets"})


        vim.keymap.set({"i","s"}, "<c-K>", function() 
            ls.expand()
        end, {silent = true})
    end,
    }
}





