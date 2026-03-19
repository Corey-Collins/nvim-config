local nvim_lsp = require('lspconfig')
local configs = require("lspconfig.configs")
local util = require("lspconfig.util")

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

-- Setup tabby-agent as a new language server
if not configs.tabby then
  configs.tabby = {
    default_config = {
      name = "tabby",
      cmd = { "tabby-agent", "--stdio" },
      filetypes = { "python", "javascript", "typescript", "lua", "go", "rust", "html", "css" },
      root_dir = util.root_pattern(".git", vim.fn.getcwd()),
      single_file_support = true,
    },
  }
end

require("tailwind-tools").setup()

-- Helper to detect env path
local function get_python_path(root_dir)
  local env_python = root_dir .. "/env/bin/python"
  if vim.fn.filereadable(env_python) == 1 then
    return env_python
  else
    return nil
  end
end

local servers = { 'pyright', 'tailwindcss', 'eslint', 'ts_ls', 'jsonls', 'volar' }

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

local function find_venv(start_dir)
  local dir = vim.fn.fnamemodify(start_dir, ":p") -- absolute path
  while dir and dir ~= "/" do
    local candidate = vim.fs.joinpath(dir, "env", "bin", "python")
    print("Checking for:", candidate) -- debugging
    if vim.fn.filereadable(candidate) == 1 then
      print("Found venv at:", candidate)
      return candidate
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end
  return nil
end

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
      root_dir = util.root_pattern(".git", vim.fn.getcwd()),
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
