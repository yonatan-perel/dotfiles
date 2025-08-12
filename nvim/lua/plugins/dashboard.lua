return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    require('dashboard').setup {
      theme = 'hyper',
      config = {
        shortcut = {
          { desc = '󰒲 Lazy', group = '@property', action = 'Lazy', key = 'l' },
          { desc = '󰿘 Mason', group = 'Label', action = 'Mason', key = 'm' },
        },
        project = { enable = false },
      },
    }
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons' }
}