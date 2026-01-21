return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons'
  },
  keys = {
    { "<leader>Ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>Fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>Fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>Fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>Fr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
    { "<leader>Fs", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
    { "<leader>Fd", "<cmd>Telescope lsp_definitions<cr>", desc = "Definitions" },
    { "<leader>Fi", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
    { "<leader>Fc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
    { "<leader>Ft", "<cmd>Telescope git_status<cr>", desc = "Git status" },
  },
}