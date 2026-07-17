return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      cpp = { 'clang-format' },
      python = { 'black' },
      sh = { 'shfmt' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      css = { 'prettierd' },
      html = { 'prettierd' },
    },
    format_on_save = function(bufnr)
      return {
        timeout_ms = 3000,
        lsp_fallback = true,
      }, function(err)
        if not err then
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(bufnr) then
              vim.api.nvim_buf_call(bufnr, function()
                pcall(vim.cmd, 'silent! GuessIndent')
              end)
            end
          end)
        end
      end
    end,
  },
}
