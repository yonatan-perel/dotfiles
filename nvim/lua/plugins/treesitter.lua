return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    opts = {
        ensure_installed = { "lua", "vim", "vimdoc", "sql", "javascript", "html", "python", "go" },
        sync_install = true,
        highlight = { enable = true },
        indent = { enable = true },
    },
}
