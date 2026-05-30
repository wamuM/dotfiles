return {
{
  "hrsh7th/nvim-cmp",
  version = false, -- last release is way too old
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },
  opts = function()
    -- Register nvim-cmp lsp capabilities
    vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

    local cmp = require("cmp")
    local autocomplete_enabled = true;
    vim.keymap.set({"n","i"},"<C-A-Space>", function() 
            autocomplete_enabled = not autocomplete_enabled
            cmp.setup({completion = {autocomplete = autocomplete_enabled
                and { cmp.TriggerEvent.TextChanged }
                or false,
            }})
            cmp.abort()
            vim.notify("Autocomplete ".. (autocomplete_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
    end, {desc = "Toggle autocomplete"})
    local defaults = require("cmp.config.default")()
    return {
        completion = {
            completeopt = "menu,menuone,noinsert",
        },
        preselect = cmp.PreselectMode.Item,
        mapping = cmp.mapping.preset.insert({
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-i>"] = cmp.mapping.scroll_docs(4),
            ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-m>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<S-Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-o>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({select = true}),
        }),
        sources = cmp.config.sources({
            { name = 'luasnip' },
            { name = "nvim_lsp" },
            { name = "path" },
        }, {
            { name = "buffer" },
        }),
        experimental = {
            ghost_text   = true
        },
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
        },
    }
  end,
}
}
