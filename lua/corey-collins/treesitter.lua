local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = "all", -- one of "all" or a list of languages
	ignore_install = { "" }, -- List of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "css" }, -- list of language that will be disabled
	},
	autopairs = {
		enable = true,
	},
	-- indent = { enable = true, disable = { "python", "css" } },
	indent = { enable = true },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
})

-- Disable deprecated Treesitter module for commentstring
vim.g.skip_ts_context_commentstring_module = true

-- Proper setup for ts_context_commentstring
require('ts_context_commentstring').setup {}
