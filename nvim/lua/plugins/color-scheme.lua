return {
    {
        "yonatan-perel/lake-dweller.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("lake-dweller").setup({ transparent = false, italic_comments = true })
            vim.cmd.colorscheme("lake-dweller")
        end,
    },
}
