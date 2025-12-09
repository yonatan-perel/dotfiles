return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        modes = {
            diagnostics = {
                focus = true,
            },
        },
    },
    keys = {
        { "<leader>x", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle Trouble diagnostics" },
    },
}
