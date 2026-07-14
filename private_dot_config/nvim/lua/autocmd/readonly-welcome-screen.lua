local startup_group = vim.api.nvim_create_augroup("NativeIntroOverlay", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = startup_group,
  callback = function()
    if vim.fn.argc() == 0 and vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
      vim.bo.modifiable = false
      vim.bo.readonly = true

      local text_above = "I use"
      local text_below = "eovim, btw."

      local win_width = vim.api.nvim_win_get_width(0)
      local win_height = vim.api.nvim_win_get_height(0)

      local base_row = math.floor((win_height - 20) / 2)
      local row_above = math.max(0, base_row + 4)
      local row_below = math.max(0, base_row + 4)

      local col_above = math.floor((win_width - vim.fn.strdisplaywidth(text_above)) / 2 - 7)
      local col_below = math.floor((win_width - vim.fn.strdisplaywidth(text_below)) / 2 + 8)

      local buf_above = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf_above, 0, -1, false, { text_above })

      local buf_below = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf_below, 0, -1, false, { text_below })

      local win_opts_above = {
        relative = "editor",
        width = vim.fn.strdisplaywidth(text_above),
        height = 1,
        row = row_above,
        col = col_above,
        style = "minimal",
        focusable = false,
        noautocmd = true,
      }

      local win_opts_below = {
        relative = "editor",
        width = vim.fn.strdisplaywidth(text_below),
        height = 1,
        row = row_below,
        col = col_below,
        style = "minimal",
        focusable = false,
        noautocmd = true,
      }

      local float_above = vim.api.nvim_open_win(buf_above, false, win_opts_above)
      local float_below = vim.api.nvim_open_win(buf_below, false, win_opts_below)

      vim.api.nvim_win_set_option(float_above, "winhl", "Normal:Normal,NormalFloat:Normal")
      vim.api.nvim_win_set_option(float_below, "winhl", "Normal:Normal,NormalFloat:Normal")

      local function dismiss()
        if vim.api.nvim_win_is_valid(float_above) then
          vim.api.nvim_win_close(float_above, true)
        end
        if vim.api.nvim_win_is_valid(float_below) then
          vim.api.nvim_win_close(float_below, true)
        end
        pcall(vim.api.nvim_del_augroup_by_id, startup_group)
      end

      vim.api.nvim_create_autocmd({ "InsertEnter", "CursorMoved", "BufDelete", "TextChanged" }, {
        group = startup_group,
        callback = dismiss,
      })
    end
  end,
})
