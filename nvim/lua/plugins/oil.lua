return {
    'stevearc/oil.nvim',
    lazy = false,
    config = function()
        require("oil").setup({
            view_options = {
                show_hidden = true,
            },
            keymaps = {
                ["q"] = "actions.close",
            },
        })
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
    },
}

