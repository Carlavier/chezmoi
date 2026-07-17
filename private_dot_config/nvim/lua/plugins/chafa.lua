return {
    "princejoogie/chafa.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "m00qek/baleia.nvim",
    },
    config = function()
        local baleia = require("baleia").setup({
            line_starts_at = 1,
        })

        vim.api.nvim_create_user_command("ViewImage", function()
            local filepath = vim.fn.expand("%:p")
            if filepath == "" then
                vim.notify("No file active", vim.log.levels.ERROR)
                return
            end

            -- 1. Calculate exact 80% window size
            local screen_width = vim.o.columns
            local screen_height = vim.o.lines
            local float_width = math.floor(screen_width * 0.8)
            local float_height = math.floor(screen_height * 0.8)

            local col = math.floor((screen_width - float_width) / 2)
            local row = math.floor((screen_height - float_height) / 2)

            -- 2. Create the scratch buffer
            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_name(buf, filepath .. " (Preview)")
            vim.api.nvim_set_option_value("filetype", "chafa", { buf = buf })

            -- 3. Configure and open the float
            local win_opts = {
                relative = "editor",
                width = float_width,
                height = float_height,
                col = col,
                row = row,
                style = "minimal",
                border = "rounded",
            }
            local win = vim.api.nvim_open_win(buf, true, win_opts)

            -- Bind 'q' to close
            vim.keymap.set("n", "q", function()
                if vim.api.nvim_win_is_valid(win) then
                    vim.api.nvim_win_close(win, true)
                end
            end, { buffer = buf, silent = true, nowait = true })

            -- 4. Calculate maximum dimensions for chafa inside the float
            local max_cols = math.max(10, float_width - 4)
            local max_rows = math.max(5, float_height - 2)

            -- Run chafa
            local cmd = string.format(
                "chafa --colors truecolor --align center --size %dx%d %s",
                max_cols,
                max_rows,
                vim.fn.shellescape(filepath)
            )
            local output = vim.fn.systemlist(cmd)

            -- Helper to strip ALL ANSI escape codes (colors, cursors, etc.) to get pure text length
            local function get_visual_width(line)
                local clean = line:gsub("\27%[[%d;]*%a", ""):gsub("%[%?%d+[hl]", "")
                return vim.fn.strdisplaywidth(clean)
            end

            -- 5. Clean up cursor control codes while keeping color sequences
            local raw_cleaned = {}
            local max_visual_width = 0
            for _, line in ipairs(output) do
                local cleaned = line:gsub("\27%[%?%d+[hl]", ""):gsub("%[%?%d+[hl]", "")
                table.insert(raw_cleaned, cleaned)

                local visual_len = get_visual_width(cleaned)
                if visual_len > max_visual_width then
                    max_visual_width = visual_len
                end
            end

            -- 6. Center the image horizontally and vertically
            local final_lines = {}
            local actual_height = #raw_cleaned

            -- Vertical centering padding
            local top_padding = math.max(0, math.floor((float_height - actual_height) / 2))
            for _ = 1, top_padding do
                table.insert(final_lines, "")
            end

            -- Horizontal centering padding (prepending spaces based on actual visual width)
            local left_padding_amt = math.max(0, math.floor((float_width - max_visual_width) / 2))
            local left_space = string.rep(" ", left_padding_amt)

            for _, line in ipairs(raw_cleaned) do
                table.insert(final_lines, left_space .. line)
            end

            -- Fill remaining bottom padding to keep layout stable
            local bottom_padding = float_height - #final_lines
            for _ = 1, bottom_padding do
                table.insert(final_lines, "")
            end

            -- Render and colorize
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, final_lines)
            baleia.once(buf)
        end, {})
    end,
}
