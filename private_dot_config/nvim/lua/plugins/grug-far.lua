return {
  'MagicDuck/grug-far.nvim',
  config = function()
    require('grug-far').setup({})
  end,
  keys = {
    {
      '<leader>sr',
      function()
        require('grug-far').open()
      end,
      mode = { 'n', 'v' },
      desc = 'Search and Replace (grug-far)',
    },
    {
      '<leader>sw',
      function()
        require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })
      end,
      mode = 'n',
      desc = 'Search current word (grug-far)',
    },
  },
}
