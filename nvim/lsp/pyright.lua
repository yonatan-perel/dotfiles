local function get_python_path(workspace)
  local venv_path = workspace .. '/.venv/bin/python'
  if vim.fn.filereadable(venv_path) == 1 then
    return venv_path
  end
  return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
end

return {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json', '.git' },
  capabilities = require('lsp-utils').get_capabilities(),
  on_init = function(client)
    local python_path = get_python_path(client.config.root_dir)
    client.config.settings.python.pythonPath = python_path
    client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
  end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'workspace',
      },
    },
  },
}