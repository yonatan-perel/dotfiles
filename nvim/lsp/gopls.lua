return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
  capabilities = require('lsp-utils').get_capabilities(),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
  on_attach = function(client, bufnr)
    -- Disable semantic tokens so Treesitter handles highlights
    client.server_capabilities.semanticTokensProvider = nil
  end,
}
