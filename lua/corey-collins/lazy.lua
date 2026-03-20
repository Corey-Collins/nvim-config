-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- Group 1: Simple plugins (theme, icons, utilities)
  {
    "EdenEast/nightfox.nvim",
    lazy = false, -- Load immediately since it's our colorscheme
    priority = 1000, -- Load before other plugins
  },
  {
    "kyazdani42/nvim-web-devicons",
    lazy = true, -- Loaded when needed by other plugins
  },
  {
    "tpope/vim-surround",
    event = "VeryLazy", -- Load after startup
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = false, -- Must load immediately (required by telescope, avante, etc)
  },

  -- Group 2: Core editing (treesitter, autopairs, autotag)
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    opts = {
      ensure_installed = "all",
      ignore_install = { "" },
      highlight = {
        enable = true,
        disable = { "css" },
      },
      autopairs = {
        enable = true,
      },
      indent = { enable = true },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
    },
    config = function(_, opts)
      -- Disable deprecated Treesitter module for commentstring
      vim.g.skip_ts_context_commentstring_module = true

      -- Use the new API - require nvim-treesitter directly
      require('nvim-treesitter').setup(opts)

      -- Setup ts_context_commentstring
      require('ts_context_commentstring').setup {}
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = true,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require('nvim-autopairs').setup({
        check_ts = true, -- Enable Treesitter integration
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "javascriptreact", "typescriptreact", "vue", "javascript", "typescript" },
    config = function()
      require('nvim-ts-autotag').setup({
        filetypes = { "html", "xml", "javascriptreact", "typescriptreact", "vue", "javascript", "typescript" },
      })
    end,
  },

  -- Group 3: LSP & Completion
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require('corey-collins.lspconfig')
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "onsails/lspkind-nvim",
    },
    config = function()
      require('corey-collins.nvimcmp')
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = true,
  },
  {
    "hrsh7th/cmp-buffer",
    lazy = true,
  },
  {
    "hrsh7th/cmp-path",
    lazy = true,
  },
  {
    "hrsh7th/cmp-cmdline",
    lazy = true,
  },
  {
    "hrsh7th/cmp-vsnip",
    lazy = true,
  },
  {
    "hrsh7th/vim-vsnip",
    event = "InsertEnter",
  },
  {
    "onsails/lspkind-nvim",
    lazy = true,
  },

  -- Group 4: Navigation (telescope, nvim-tree, trouble)
  {
    "folke/trouble.nvim",
    opts = {},
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require('corey-collins.telescope')
    end,
  },
  {
    "kyazdani42/nvim-tree.lua",
    event = "VeryLazy",
    dependencies = { "nvim-web-devicons" },
    config = function()
      require('corey-collins.nvimtree')
    end,
  },

  -- Group 5: Language-specific
  {
    "rust-lang/rust.vim",
    ft = "rust",
  },
  {
    "hashivim/vim-terraform",
    ft = "terraform",
  },

  -- Group 6: Debugger (nvim-dap suite)
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    config = function()
      require('corey-collins.dapui')
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
  },
  {
    "nvim-neotest/nvim-nio",
    lazy = true,
  },

  -- Group 7: AI tools (avante & dependencies)
  {
    "yetone/avante.nvim",
    branch = "main",
    build = "make",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "zbirenbaum/copilot.lua",
      "MeanderingProgrammer/render-markdown.nvim",
      "HakonHarnes/img-clip.nvim",
      "folke/snacks.nvim",
    },
    config = function()
      require('corey-collins.avante')
    end,
  },
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    lazy = true,
  },
  {
    "HakonHarnes/img-clip.nvim",
    lazy = true,
  },
  {
    "stevearc/dressing.nvim",
    lazy = true,
  },
  {
    "folke/snacks.nvim",
    lazy = true,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require('copilot').setup()
    end,
  },

  -- Group 8: Remaining plugins
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'carbonfox',
        },
      })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require('corey-collins.toggleterm')
    end,
  },
  {
    "prabirshrestha/vim-lsp",
    event = "VeryLazy",
  },
  {
    "mrcjkb/rustaceanvim",
    ft = "rust",
  },
}, {
  -- Lazy.nvim configuration options
  ui = {
    border = "rounded",
  },
  checker = {
    enabled = false, -- Don't automatically check for updates
  },
  change_detection = {
    enabled = true,
    notify = false, -- Don't spam notifications
  },
})
