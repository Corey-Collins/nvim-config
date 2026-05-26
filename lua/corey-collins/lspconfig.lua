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

-- Vue Language Server path (installed globally via pnpm)
-- NOTE: Update version number when upgrading @vue/language-server
local vue_language_server_path = '/home/corey/.local/share/pnpm/global/5/.pnpm/@vue+language-server@3.3.2_typescript@6.0.3/node_modules/@vue/language-server'

-- Configure LSP servers using new vim.lsp.config API
vim.lsp.config('pyright', {
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.lsp.config('eslint', {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- TypeScript server with Vue plugin support
vim.lsp.config('ts_ls', {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  init_options = {
    plugins = {
      {
        name = '@vue/typescript-plugin',
        location = vue_language_server_path,
        languages = { 'vue' }
      }
    }
  }
})

vim.lsp.config('jsonls', {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Vue Language Server (handles template/CSS in .vue files)
vim.lsp.config('vue_ls', {
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Tailwind CSS Language Server (provides class name completions and hover info)
vim.lsp.config('tailwindcss', {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
})

-- Enable all configured servers
vim.lsp.enable({ 'pyright', 'eslint', 'ts_ls', 'jsonls', 'vue_ls', 'tailwindcss' })
