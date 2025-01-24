require('nvim-autopairs').setup({
  check_ts = true, -- Enable Treesitter integration
})

require('nvim-ts-autotag').setup({
  filetypes = { "html", "xml", "javascriptreact", "typescriptreact", "vue" }, -- Enable for these filetypes
})

-- Optional: Enable completion integration with nvim-cmp
-- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
-- local cmp = require('cmp')
-- cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
