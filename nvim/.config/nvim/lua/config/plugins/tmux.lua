return {
    {
    "christoomey/vim-tmux-navigator",
    cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
        "TmuxNavigatorProcessList",
    },
    keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc="Go to left window (tmux compatible)" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc="Go to down window (tmux compatible)"  },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc="Go to up window (tmux compatible) "},
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc="Go to right window (tmux compatible)" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc="Go to previous window (tmux compatible)"},
    },},
}
