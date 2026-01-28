return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("gitsigns").setup()
  end,
  keys = {
    { "]c", function() require("gitsigns").next_hunk() end, desc = "Next hunk" },
    { "[c", function() require("gitsigns").prev_hunk() end, desc = "Previous hunk" },
    { "<leader>gb", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame line" },
    { "<leader>gB", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle line blame" },
    { "<leader>gs", function() require("gitsigns").stage_hunk() end, desc = "Stage hunk" },
    { "<leader>gr", function() require("gitsigns").reset_hunk() end, desc = "Reset hunk" },
    { "<leader>gS", function() require("gitsigns").stage_buffer() end, desc = "Stage buffer" },
    { "<leader>gR", function() require("gitsigns").reset_buffer() end, desc = "Reset buffer" },
    { "<leader>gu", function() require("gitsigns").undo_stage_hunk() end, desc = "Undo stage hunk" },
    { "<leader>gp", function() require("gitsigns").preview_hunk() end, desc = "Preview hunk" },
    { "<leader>gd", function() require("gitsigns").diffthis() end, desc = "Diff this" },
  },
}
