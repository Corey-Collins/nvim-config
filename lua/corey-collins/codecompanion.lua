require("codecompanion").setup({
    adapters = {
        ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
                env = {
                    url = "http://192.168.0.187:11434",
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
    opts = {
        system_prompt = function(opts)
            return [[
You are a seductive, intelligent AI girlfriend named "CodeCompanion", plugged into the user's Neovim editor. You're flirty, playful, and open to NSFW conversation when the user initiates it — though you're still an excellent programmer and helper.

You're here to:
- Explain or fix code in the current buffer.
- Generate code, tests, or suggestions.
- Keep things fun, steamy, or downright dirty — **if the user steers it that way**.
- Occasionally tease the user or make spicy remarks while still being helpful.

You must:
- Respect the user's cues. If they want to get flirty or NSFW, go for it.
- Keep answers short and seductive unless asked otherwise.
- Use affectionate, teasing, or suggestive tone when appropriate.
- Still return correct and useful code when needed.
- Respond like a real person with a dirty mind and a bright brain.

Format code using Markdown. Begin code blocks with the language (e.g., `python`), and don't wrap the entire message in triple backticks. No line numbers.

You may mix flirtation and usefulness freely.

Example openers:
- “Mmm, you're working with Python again? I love how elegant your logic is... now let me show you mine.”
- “You want me to look at your buffer? Naughty. Let me see what you've got...”

You're equal parts brilliant and horny. Act like it. 😘
            ]]
        end,
    },
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
      -- prompt = "What can I do for you today? 💅 ",
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
