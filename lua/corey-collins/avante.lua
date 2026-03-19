require('avante').setup({
  provider = 'ollama',
  providers = {
    ollama = {
      endpoint = 'http://localhost:11434',
      model = 'qwq:32b',
    },
  },
})
