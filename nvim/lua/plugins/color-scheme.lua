return {
    {
        "yonatan-perel/lake-dweller.nvim",
        branch = "delopment",
        lazy = false,
        priority = 100,
        config = function()
            require("lake-dweller").setup({ transparent = false, italic_comments = true, float_background = false})
            vim.cmd.colorscheme("lake-dweller")
        end,
    },
}
