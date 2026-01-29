return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    require('dashboard').setup {
      theme = 'hyper',
      config = {
        header = {
          "",
          "",
          "                    ██████████████                    ",
          "                ████░░░░░░░░░░░░░░████                ",
          "              ██░░░░░░░░░░░░░░░░░░░░░░██              ",
          "            ██░░░░░░░░░░░░░░░░░░░░░░░░░░██            ",
          "          ██░░░░░░████░░░░░░░░████░░░░░░░░██          ",
          "          ██░░░░░░████░░░░░░░░████░░░░░░░░██          ",
          "        ██░░░░░░░░░░░░░░██░░░░░░░░░░░░░░░░░░██        ",
          "～～～～～～██░░░░░░░░░░░░██░░░░░░░░░░░░░░░░░░██～～～～～～",
          "  ～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～  ",
          "    ～～～～～～～～～～～～～～～～～～～～～～～～～～～～    ",
          "～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～",
          "",
          "",
        },
        shortcut = {
          { desc = '󰒲 Lazy', group = '@property', action = 'Lazy', key = 'l' },
          { desc = '󰿘 Mason', group = 'Label', action = 'Mason', key = 'm' },
        },
        project = { enable = false },
        mru = { limit = 10 },
      },
    }
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons' }
}
