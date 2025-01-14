-- Define paths for codelldb binary and liblldb library
local current_file = debug.getinfo(1, "S").source:sub(2)
local current_dir = current_file:match("(.*/)")
local codelldb_path = current_dir .. "tools/codelldb/darwin-arm64/extension/adapter/codelldb"
local liblldb_path = current_dir .. "tools/codelldb/darwin-arm64/extension/lldb/lib/liblldb.dylib"

local bit = require("bit") -- Require the `bit` library for bitwise operations

-- Store the last used build command
local last_build_command = nil

-- Function to prompt for the build command
local function get_build_command()
  if last_build_command then
    -- Use the last command by default
    return vim.fn.input("Build command (press Enter to reuse): ", last_build_command)
  else
    -- Default to `cargo build`
    return vim.fn.input("Build command: ", "cargo build", "file")
  end
end

local function build_project()
  local build_cmd = get_build_command()
  if build_cmd == "" then
    vim.notify("No build command provided. Skipping build.", vim.log.levels.WARN)
    return false
  end

  vim.notify("Building project with: " .. build_cmd, vim.log.levels.INFO)

  -- Run the build command synchronously
  local result = os.execute(build_cmd .. " > /dev/null 2>&1")
  if result ~= 0 then
    vim.notify("Build failed. Fix errors before debugging.", vim.log.levels.ERROR)
    return false
  end

  last_build_command = build_cmd
  return true
end

-- Variable to store the last selected executable
local last_selection = nil

local function select_executable()
  -- Get all files in `target/debug`
  local debug_dir = vim.fn.getcwd() .. "/target/debug"
  local binaries = vim.fn.glob(debug_dir .. "/*", 0, 1) -- Get list of files
  if #binaries == 0 then
    vim.notify("No binaries found in " .. debug_dir, vim.log.levels.ERROR)
    return nil
  end

  -- Filter to include only executable files
  local executables = {}
  for _, binary in ipairs(binaries) do
    local stat = vim.loop.fs_stat(binary)
    if stat and stat.type == "file" and (bit.band(stat.mode, 1) ~= 0 or bit.band(stat.mode, 8) ~= 0 or bit.band(stat.mode, 64) ~= 0) then
      table.insert(executables, binary)
    end
  end

  if #executables == 0 then
    vim.notify("No executable binaries found in " .. debug_dir, vim.log.levels.ERROR)
    return nil
  end

  -- If there is only one executable, automatically select it
  if #executables == 1 then
    last_selection = executables[1]
    return executables[1]
  end

  -- Add a title to the list and pre-fill with last selection
  local choices = { "Select an executable (leave empty to reuse last):" }
  for i, binary in ipairs(executables) do
    choices[#choices + 1] = string.format("%d: %s", i, binary:match("([^/]+)$"))
  end

  -- Add a prompt for reusing the last selection
  if last_selection then
    vim.notify(string.format("Last selected executable: %s", last_selection:match("([^/]+)$")), vim.log.levels.INFO)
  end

  -- Present a selection menu
  local choice = vim.fn.inputlist(choices)
  if choice < 1 or choice > #executables then
    if last_selection then
      vim.notify("Reusing last selected executable.", vim.log.levels.INFO)
      return last_selection
    else
      vim.notify("Invalid choice and no previous selection to reuse.", vim.log.levels.WARN)
      return nil
    end
  end

  -- Save the selected executable and return it
  last_selection = executables[choice]
  return executables[choice]
end


-- Add debugging configurations for Rust
local dap = require('dap')
dap.adapters.rust = {
  type = "executable",
  command = codelldb_path,
  args = { "--liblldb", liblldb_path },
}

dap.configurations.rust = {
  {
    name = "Launch",
    type = "rust", -- Must match the adapter name
    request = "launch",
    -- program = function()
    --   return select_executable() or vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
    -- end,
    program = function()
      -- Build the project first
      if not build_project() then
        return nil
      end

      -- Select the executable to run
      return select_executable() or vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {}, -- Arguments to pass to the program being debugged
  },
}

vim.g.rustaceanvim = {
  server = {
    on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
      vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<space>f', vim.lsp.buf.format, opts)
    end,
  },
}
