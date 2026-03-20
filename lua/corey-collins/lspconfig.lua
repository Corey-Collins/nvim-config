vim.diagnostic.config({
  virtual_text = {
    -- prefix = "●",  -- or ">>", customize as you prefer
    spacing = 2,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Common on_attach function
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Configure LSP servers using new vim.lsp.config API
vim.lsp.config('pyright', {
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.lsp.config('eslint', {
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.lsp.config('ts_ls', {
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.lsp.config('jsonls', {
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.lsp.config('volar', {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Setup custom tabby-agent language server
vim.lsp.config('tabby', {
  cmd = { "tabby-agent", "--stdio" },
  filetypes = { "python", "javascript", "typescript", "lua", "go", "rust", "html", "css" },
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Enable all configured servers
vim.lsp.enable({ 'pyright', 'eslint', 'ts_ls', 'jsonls', 'volar', 'tabby' })
