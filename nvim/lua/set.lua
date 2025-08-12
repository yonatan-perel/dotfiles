vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "<leader>i", vim.lsp.buf.format)

vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")
vim.keymap.set("v", "H", "^")
vim.keymap.set("v", "L", "$")

vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>h", vim.lsp.buf.signature_help)

vim.keymap.set({"n", "v"}, "<C-y>", [["+y]])
vim.keymap.set({"n", "v"}, "<C-p>", [["+p]])

vim.keymap.set("n", "'", "%")

vim.keymap.set('n', '<C-w>\\', '<cmd>vsplit<cr>', { desc = 'Vertical split' })
vim.keymap.set('n', '<C-w>-', '<cmd>split<cr>', { desc = 'Horizontal split' })
vim.keymap.set('n', '<C-w>c', '<cmd>close<cr>', { desc = 'Close current pane' })

