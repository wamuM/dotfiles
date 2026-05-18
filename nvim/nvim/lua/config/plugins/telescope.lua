return{{
  "nvim-telescope/telescope.nvim",
  dependencies = { 
      "nvim-lua/plenary.nvim",
     {"nvim-telescope/telescope-fzf-native.nvim", build = "make"},
  },
  config = function()
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = {"node_modules", ".git/"},
      },
      extensions = {
            fzf = {}
      },
    })
    require("telescope").load_extension("fzf")

    vim.keymap.set("n","<leader>ff",function()
        require("telescope.builtin").find_files()
    end)
    vim.keymap.set("n","<leader>en",function()
        require("telescope.builtin").find_files({
            cwd = vim.fn.stdpath("config")
        })
    end)
    vim.keymap.set("n","<leader>fg",function()
        require("telescope.builtin").live_grep()
    end)
    vim.keymap.set("v","<leader>fg",function()
        require("telescope.builtin").grep_string()
    end)
    vim.keymap.set("n","<leader>ft",function()
        require("telescope.builtin").treesitter()
    end)
    vim.keymap.set("n","<leader>fh",function()
        require("telescope.builtin").help_tags()
    end)
  end,
}}
