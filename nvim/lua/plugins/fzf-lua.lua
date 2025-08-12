return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
    { "<leader>fs", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
    { "gr", "<cmd>FzfLua lsp_references<cr>", desc = "References" },
  },
}
