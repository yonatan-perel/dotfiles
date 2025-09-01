return {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
  capabilities = require('lsp-utils').get_capabilities(),
  init_options = {
    preferences = {
      disableSuggestions = true,
    },
  },
}