local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
 
-- Insert --

-- Visual --

-- Normal --
-- Buffers
keymap("n", "<C-b>", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<A-l>", ":bnext<CR>", opts)
keymap("n", "<A-h>", ":bprevious<CR>", opts)
-- Window navigation handled by vim-tmux-navigator plugin
-- Uses <C-h/j/k/l> to navigate Neovim splits and tmux panes seamlessly
-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)
-- Telescope
keymap("n", "<leader>o", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>p", "<cmd>Telescope live_grep<cr>", opts)
-- NvimTree
keymap("n", "<leader>e", "<cmd>:NvimTreeToggle<cr>", opts)
-- Debugger
keymap("n", "<leader>dt", "<cmd>lua require'dapui'.toggle()<cr>", opts)
keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
keymap("n", "<leader>dr", "<cmd>lua require('dapui').close(); require('dapui').setup(); require('dapui').open()<cr>", opts)
-- Commenting with nvim-ts-context-commentstring
-- keymap("n", "gcc", "<cmd>lua require('ts_context_commentstring.internal').update_commentstring()<CR>gcc", opts)

-- Diffview (git diff viewer) - toggle on <leader>gd
local function toggle_diffview()
  local lib = require("diffview.lib")
  local view = lib.get_current_view()

  if view then
    -- Diffview is open in current tab, close it
    vim.cmd("DiffviewClose")
  else
    -- Check if diffview is open in any other tab by looking for DiffviewFiles filetype
    local diffview_tabpage = nil
    for i = 1, vim.fn.tabpagenr("$") do
      local tabnr_wins = vim.fn.tabpagewinnr(i, "$")
      for j = 1, tabnr_wins do
        local winid = vim.fn.win_getid(j, i)
        local bufnr = vim.fn.winbufnr(winid)
        local filetype = vim.fn.getbufvar(bufnr, "&filetype")
        if filetype == "DiffviewFiles" then
          diffview_tabpage = i
          break
        end
      end
      if diffview_tabpage then break end
    end

    if diffview_tabpage then
      -- Switch to the tab with diffview open
      vim.cmd("tabnext " .. diffview_tabpage)
    else
      -- Open diffview in current tab
      vim.cmd("DiffviewOpen")
    end
  end
end

vim.keymap.set("n", "<leader>gd", toggle_diffview, opts)
