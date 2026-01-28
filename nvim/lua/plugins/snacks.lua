return {
  "folke/snacks.nvim",
  lazy = false,
  keys = {
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
    { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "Workspace symbols" },
    { "gr", function() Snacks.picker.lsp_references() end, desc = "References" },
  },
  opts = {
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            ["<c-q>"] = { "qflist", mode = { "i", "n" } },
          },
        },
      },
    },
  },
}
