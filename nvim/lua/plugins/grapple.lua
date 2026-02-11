return {
  "cbochs/grapple.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>a", "<cmd>Grapple toggle<cr>" },
    { "<leader>e", "<cmd>Grapple toggle_tags<cr>" },
    { "<leader>1", "<cmd>Grapple select index=1<cr>" },
    { "<leader>2", "<cmd>Grapple select index=2<cr>" },
    { "<leader>3", "<cmd>Grapple select index=3<cr>" },
    { "<leader>4", "<cmd>Grapple select index=4<cr>" },
    { "<C-n>", "<cmd>Grapple cycle_tags next<cr>" },
    { "<C-p>", "<cmd>Grapple cycle_tags prev<cr>" },
  },
  opts = {
    scope = "git_branch",
  },
}
