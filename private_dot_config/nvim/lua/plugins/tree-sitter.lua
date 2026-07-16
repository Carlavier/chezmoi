return {
  -- We don't need external plugins anymore since Tree-sitter is fixed!
  -- This hooks directly into Neovim 0.12's native comment engine.
  dir = vim.fn.stdpath('config'),
  name = 'native_tsx_comments',
  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'typescriptreact', 'javascriptreact' },
      callback = function()
        -- Directly assigns the TSX structural query rule to the buffer
        vim.bo.commentstring = '{/* %s */}'
      end,
    })
  end,
}
