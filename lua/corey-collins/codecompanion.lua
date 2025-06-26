require("codecompanion").setup({
   adapters = {
        ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
                env = {
                    url = "http://localhost:11434",
                },
                parameters = {
                    sync = true,
                },
                -- schema = {
                --     model = {
                --         default = "qwen:32b"
                --     }
                -- }
            })
        end,
        },
    default_adapter = "ollama",
    strategies = {
        chat = {
          adapter = "ollama",
            keymaps = {
                send = {
                  modes = { n = "<C-s>", i = "<C-s>" },
                  opts = {},
                },
                close = {
                  modes = { n = "<C-q>", i = "<C-q>" },
                  opts = {},
                },
                -- Add further custom keymaps here
            },
        },
        inline = {
          adapter = "ollama",
        },
        cmd = {
          adapter = "ollama",
        },
    },
    -- opts = {
    --     system_prompt = function(opts)
    --         return [[custom prompt goes here]]
    --     end,
    -- },
    -- display = {
    --     action_palette = {
    --         width = 95,
    --         height = 10,
    --         prompt = "Prompt ", -- Prompt used for interactive LLM calls
    --         provider = "telescope", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
    --         opts = {
    --             show_default_actions = true, -- Show the default actions in the action palette?
    --             show_default_prompt_library = true, -- Show the default prompt library in the action palette?
    --         },
    --     },
    -- },
    display = {
        action_palette = {
          provider = "telescope",
          -- prompt = "What can I do for you today? ",
          width = 95,
          height = 10,
          opts = {
            show_default_actions = true,
            show_default_prompt_library = true,
          },
    },
    chat = {
      -- Change the default icons
      icons = {
        buffer_pin = " ",
        buffer_watch = "👀 ",
      },

      -- Alter the sizing of the debug window
      debug_window = {
        ---@return number|fun(): number
        width = vim.o.columns - 5,
        ---@return number|fun(): number
        height = vim.o.lines - 2,
      },

      -- Options to customize the UI of the chat buffer
      window = {
        layout = "vertical", -- float|vertical|horizontal|buffer
        position = "right", -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
        border = "single",
        height = 0.8,
        width = 0.3,
        relative = "editor",
        full_height = false, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
        opts = {
          breakindent = true,
          cursorcolumn = false,
          cursorline = false,
          foldcolumn = "0",
          linebreak = true,
          list = false,
          numberwidth = 1,
          signcolumn = "no",
          spell = false,
          wrap = true,
        },
      },

      ---Customize how tokens are displayed
      ---@param tokens number
      ---@param adapter CodeCompanion.Adapter
      ---@return string
      -- token_count = function(tokens, adapter)
      --   return " (" .. tokens .. " tokens)"
      -- end,
    },
  },
})

-- vim.api.nvim_create_autocmd("User", {
--     pattern = "CodeCompanionChatOpened",
--     callback = function()
--         local win = vim.api.nvim_get_current_win()
--         local width = math.floor(vim.o.columns * 0.35) -- 35% of screen width
--
--         vim.api.nvim_win_set_config(win, {
--             relative = "editor",
--             width = width,
--             height = math.floor(vim.o.lines * 0.9),
--             row = 1,
--             col = vim.o.columns - width - 1,
--             border = "rounded",
--             style = "minimal",
--         })
--     end,
-- })

-- vim.api.nvim_create_autocmd("User", {
--   pattern = "CodeCompanionChatOpened",
--   callback = function()
--     local win = vim.api.nvim_get_current_win()
--     local cols, lines = vim.o.columns, vim.o.lines
--     local width = math.floor(cols * 0.35)
--
--     vim.api.nvim_win_set_config(win, {
--       relative = "editor",
--       style = "minimal",
--       border = "rounded",
--       width = width,
--       height = math.floor(lines * 0.9),
--       row = 1,
--       col = cols - width - 1,
--     })
--   end,
-- })

-- Toggle CodeCompanion floating chat window
local M = {}

function M.toggle_chat()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
    if bufname:match("CodeCompanionChat") then
      vim.api.nvim_win_close(win, false)
      return
    end
  end
  vim.cmd("CodeCompanionChat")
end

return M

-- vim.api.nvim_create_autocmd("User", {
--   pattern = "CodeCompanionRequestStart",
--   callback = function(args)
--     print("🤖 Using adapter:", args.data.adapter)
--     print("📦 Model:", args.data.parameters.model)
--   end,
-- })
