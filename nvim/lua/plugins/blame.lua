return {
  "FabijanZulj/blame.nvim",
  config = function()
    require("blame").setup()
  end,
  keys = {
    { "<leader>b", "<cmd>BlameToggle<cr>", desc = "Toggle Git Blame" },
  },
}