return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        modes = {
            diagnostics = {
                focus = true,
                preview = {
                    type = "split",
                    relative = "win",
                    position = "right",
                    size = 0.5,
                },
            },
        },
    },
    keys = {
        { "<leader>x", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle Trouble diagnostics" },
    },
}
