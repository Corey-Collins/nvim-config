local nvim_lsp = require('lspconfig')
local configs = require("lspconfig.configs")

-- Setup tabby-agent as a new language server
if not configs.tabby then
  configs.tabby = {
    default_config = {
      name = "tabby",
      cmd = { "tabby-agent", "--stdio" },
      filetypes = { "python", "javascript", "typescript", "lua", "go", "rust", "html", "css" },
      root_dir = require("lspconfig.util").root_pattern(".git", vim.fn.getcwd()),
      single_file_support = true,
    },
  }
end

require("tailwind-tools").setup()

local servers = { 'pyright', 'tailwindcss', 'eslint', 'ts_ls', 'jsonls', 'volar', 'eslint', 'tabby' }
-- local servers = { 'pyright', 'tailwindcss', 'ts_ls', 'jsonls', 'eslint', 'volar' }

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

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup{
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

local configs = require("lspconfig.configs")

if not configs.tabby then
  configs.tabby = {
    default_config = {
      name = "tabby",
      cmd = { "tabby-agent", "--stdio" },
      filetypes = { "python", "javascript", "typescript", "lua", "go", "rust", "html", "css" },
      root_dir = require("lspconfig.util").root_pattern(".git", vim.fn.getcwd()),
      single_file_support = true,
    },
  }
end

nvim_lsp.tabby.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- nvim_lsp.tailwindcss.setup({
--   settings = {
--     tailwindCSS = {
--       experimental = {
--         classNameColors = true, -- Enable class color previews
--       },
--     },
--   },
-- })
