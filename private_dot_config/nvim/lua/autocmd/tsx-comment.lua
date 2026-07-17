local ts_comment_group = vim.api.nvim_create_augroup('TSXNativeComments', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = ts_comment_group,
  pattern = { 'typescriptreact', 'javascriptreact' },
  callback = function()
    vim.bo.commentstring = '{/* %s */}'
  end,
})
