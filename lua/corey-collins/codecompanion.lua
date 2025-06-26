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
            })
        end,
        },
    default_adapter = "ollama",
    strategies = {
        chat = {
          adapter = "ollama",
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
  },
})

vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionChatOpened",
    callback = function()
        local win = vim.api.nvim_get_current_win()
        local width = math.floor(vim.o.columns * 0.35) -- 35% of screen width

        vim.api.nvim_win_set_config(win, {
            relative = "editor",
            width = width,
            height = math.floor(vim.o.lines * 0.9),
            row = 1,
            col = vim.o.columns - width - 1,
            border = "rounded",
            style = "minimal",
        })
    end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "CodeCompanionRequestStart",
  callback = function(args)
    print("🤖 Using adapter:", args.data.adapter)
    print("📦 Model:", args.data.parameters.model)
  end,
})
