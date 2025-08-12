_G.lsps = { "gopls", "lua_ls", "pyright", "ts_ls", "bashls" }
_G.languages = { "go", "lua", "python", "sql", "bash" }
_G.filetypes = { "go", "gomod", "gowork", "gotmpl", "lua", "sh", "bash", "sql", "py" }
vim.lsp.enable(_G.lsps)
