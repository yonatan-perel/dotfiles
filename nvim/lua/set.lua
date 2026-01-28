vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting register" })
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Escape" })

vim.keymap.set("n", "<leader>i", vim.lsp.buf.format, { desc = "Format buffer" })

vim.keymap.set("n", "H", "^", { desc = "Go to line start" })
vim.keymap.set("n", "L", "$", { desc = "Go to line end" })
vim.keymap.set("v", "H", "^", { desc = "Go to line start" })
vim.keymap.set("v", "L", "$", { desc = "Go to line end" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP hover" })
vim.keymap.set("n", "<leader>k", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>h", vim.lsp.buf.signature_help, { desc = "Signature help" })

vim.keymap.set({"n", "v"}, "<C-y>", [["+y]], { desc = "Copy to system clipboard" })
vim.keymap.set({"n", "v"}, "<C-p>", [["+p]], { desc = "Paste from system clipboard" })

vim.keymap.set("n", "'", "%", { desc = "Go to matching bracket" })
vim.keymap.set("v", "'", "%", { desc = "Go to matching bracket" })

vim.keymap.set('n', '<C-w>\\', '<cmd>vsplit<cr>', { desc = 'Vertical split' })
vim.keymap.set('n', '<C-w>-', '<cmd>split<cr>', { desc = 'Horizontal split' })
vim.keymap.set('n', '<C-w>c', '<cmd>close<cr>', { desc = 'Close current pane' })

