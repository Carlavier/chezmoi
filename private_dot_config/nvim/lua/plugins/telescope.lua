local function folder_icon_entry_maker(opts)
	opts = opts or {}
	local devicons = require("nvim-web-devicons")
	local displayer = require("telescope.pickers.entry_display").create({
		separator = " ",
		items = { { width = 2 }, { remaining = true } },
	})

	return function(line)
		if line == "" then
			return nil
		end
		local abs_path = line
		if opts.cwd and not (line:sub(1, 1) == "/" or line:match("^%a+:")) then
			abs_path = vim.fs.joinpath(opts.cwd, line)
		end

		local entry = { value = line, ordinal = line, path = abs_path }
		entry.display = function(et)
			local icon, icon_hl
			if vim.fn.isdirectory(et.path) == 1 then
				icon, icon_hl = "", "DevIconDefault"
			else
				local filename = vim.fs.basename(et.path)
				icon, icon_hl = devicons.get_icon(filename, vim.fn.fnamemodify(filename, ":e"), { default = true })
			end
			return displayer({ { icon, icon_hl }, et.value })
		end
		return entry
	end
end

local search_handlers = {
	find_files = function()
		local builtin = require("telescope.builtin")
		local cwd = vim.fn.getcwd()
		builtin.find_files({ cwd = cwd, entry_maker = folder_icon_entry_maker({ cwd = cwd }) })
	end,
	live_grep = function()
		require("telescope.builtin").live_grep()
	end,
	help_tags = function()
		require("telescope.builtin").help_tags()
	end,
	keymaps = function()
		require("telescope.builtin").keymaps()
	end,
	projects = function()
		local telescope = require("telescope")
		local action_state = require("telescope.actions.state")
		local actions = require("telescope.actions")

		local open_with_oil = function(prompt_bufnr)
			local selection = action_state.get_selected_entry()
			if not selection then
				return
			end
			local path = selection.path or selection.value or selection[1]
			if selection.cwd then
				path = vim.fs.joinpath(selection.cwd, path)
			end

			if vim.fn.isdirectory(path) == 1 then
				actions.close(prompt_bufnr)
				vim.cmd("cd " .. path)
				vim.schedule(function()
					local builtin = require("telescope.builtin")
					builtin.find_files({ cwd = path, entry_maker = folder_icon_entry_maker({ cwd = path }) })
				end)
			else
				actions.select_default(prompt_bufnr)
			end
		end

		telescope.extensions.projects.projects({
			attach_mappings = function(_, m)
				m({ "i", "n" }, "<CR>", open_with_oil)
				return true
			end,
		})
	end,
	neovim_config = function()
		local builtin = require("telescope.builtin")
		local conf = vim.fn.stdpath("config")
		builtin.find_files({
			cwd = conf,
			find_command = { "fdfind", "--type", "f", "--type", "d", "--hidden", "--strip-cwd-prefix" },
			entry_maker = folder_icon_entry_maker({ cwd = conf }),
		})
	end,
}

return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"DrKJeff16/project.nvim",
		},
		keys = {
			{ "<leader>sf", desc = "Search Files" },
			{ "<leader>[", desc = "which_key_ignore" },
			{ "<leader>sg", desc = "Search by Grep" },
			{ "<leader>sh", desc = "Search Help" },
			{ "<leader>sk", desc = "Search Keymaps" },
			{ "<leader>sp", desc = "Search Projects" },
			{ "<leader>sn", desc = "Search Neovim Config" },
		},
		config = function()
			local telescope = require("telescope")

			require("project").setup({
				manual_mode = false,
				detection_methods = { "lsp", "pattern" },
				patterns = {
					".git",
					".github",
					"_darcs",
					".hg",
					".bzr",
					".svn",
					"Makefile",
					"package.json",
					"Pipfile",
					"pyproject.toml",
					".nvim.lua",
				},
				lsp = { enabled = true, use_pattern_matching = false },
				telescope = {
					mappings = {
						n = {
							["f"] = "find_project_files",
							["b"] = "browse_project_files",
							["d"] = "delete_project",
							["s"] = "search_in_project_files",
							["r"] = "recent_project_files",
							["w"] = "change_working_directory",
						},
						i = {
							["<C-f>"] = "find_project_files",
							["<C-b>"] = "browse_project_files",
							["<C-d>"] = "delete_project",
							["<C-s>"] = "search_in_project_files",
							["<C-r>"] = "recent_project_files",
							["<C-w>"] = "change_working_directory",
						},
					},
				},
			})

			telescope.setup({
				defaults = {
					file_ignore_patterns = {
						"node_modules/",
						"%.git/",
						"venv/",
						"%.venv/",
						"__pycache__/",
						"%.o",
						"%.a",
						"%.out",
						"%.bin",
					},
					mappings = {
						i = {
							["<C-h>"] = function()
								vim.api.nvim_input("<C-w>")
							end,
						},
					},
				},
				pickers = {
					find_files = {
						find_command = { "fdfind", "--type", "f", "--type", "d", "--hidden", "--strip-cwd-prefix" },
						entry_maker = folder_icon_entry_maker({ cwd = vim.fn.getcwd() }),
					},
					live_grep = {
						additional_args = function()
							return { "--hidden" }
						end,
					},
				},
			})

			telescope.load_extension("fzf")
			telescope.load_extension("projects")

			local map = vim.keymap.set
			map("n", "<leader>sf", search_handlers.find_files, { desc = "Search Files" })
			map("n", "<leader>[", search_handlers.find_files)
			map("n", "<leader>sg", search_handlers.live_grep, { desc = "Search by Grep" })
			map("n", "<leader>sh", search_handlers.help_tags, { desc = "Search Help" })
			map("n", "<leader>sk", search_handlers.keymaps, { desc = "Search Keymaps" })
			map("n", "<leader>sp", search_handlers.projects, { desc = "Search Projects" })
			map("n", "<leader>sn", search_handlers.neovim_config, { desc = "Search Neovim Config" })
		end,
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			dashboard = {
				enabled = true,
				layout = {
					show_statusline = true,
				},
				preset = {
					keys = {
						{
							icon = "󰈔 ",
							key = "<leader>sf",
							desc = "Search Files",
							action = search_handlers.find_files,
						},
						{
							icon = " ",
							key = "<leader>sg",
							desc = "Search by Grep",
							action = search_handlers.live_grep,
						},
						{
							icon = " ",
							key = "<leader>sp",
							desc = "Search Projects",
							action = search_handlers.projects,
						},
						{
							icon = " ",
							key = "<leader>pf",
							desc = "Open Oil",
							action = function()
								local function get_root()
									local status, project = pcall(require, "project_nvim.project")
									if status then
										return project.get_visual_configs()
											or project.find_pattern_root()
											or vim.fn.getcwd()
									end
									return vim.fn.getcwd()
								end
								if vim.bo.filetype == "oil" then
									require("oil").parent()
								else
									local current = vim.api.nvim_buf_get_name(0)
									if current == "" or current:match("^oil://") then
										require("oil").open(get_root())
									else
										require("oil").open()
									end
								end
							end,
						},
						{
							icon = "󰞋 ",
							key = "<leader>sh",
							desc = "Search Help",
							action = search_handlers.help_tags,
						},
						{
							icon = "󰘳 ",
							key = "<leader>sk",
							desc = "Search Keymaps",
							action = search_handlers.keymaps,
						},
						{
							icon = "󱎘 ",
							key = ":q",
							desc = "Quit",
							action = function()
								vim.cmd("q")
							end,
						},
					},
				},
				sections = {
					function()
						local handle = io.popen("fortune -sa | cowsay 2>/dev/null")
						local lines = {}
						local max_len = 0
						if handle then
							local result = handle:read("*a")
							handle:close()
							for line in result:gmatch("[^\r\n]+") do
								table.insert(lines, line)
								if #line > max_len then
									max_len = #line
								end
							end
						end
						if #lines == 0 then
							return {
								{ text = "  Welcome to Neovim", hl = "SnacksDashboardHeader", align = "center" },
							}
						end
						local formatted_lines = {}
						for _, line in ipairs(lines) do
							local padding = string.rep(" ", max_len - #line)
							table.insert(formatted_lines, {
								text = line .. padding,
								hl = "SnacksDashboardHeader",
								align = "center",
							})
						end
						return formatted_lines
					end,
					{ type = "padding", val = 2 },
					{
						section = "keys",
						gap = 1,
					},
					{ type = "padding", val = 2 },
					{ section = "startup" },
				},
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "SnacksDashboardOpened",
				callback = function()
					vim.opt.laststatus = 3

					vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { link = "WarningMsg" })
					vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { link = "Directory" })
					vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { link = "Function" })

					local error_hl = vim.api.nvim_get_hl(0, { name = "Error", link = false })
					local todo_hl = vim.api.nvim_get_hl(0, { name = "Todo", link = false })

					local red_fg = error_hl.fg
					local pink_fg = todo_hl.fg

					vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = red_fg, bold = true })
					vim.api.nvim_set_hl(0, "SnacksDashboardSpecial", { fg = pink_fg, bold = true, italic = true })
				end,
			})
		end,
	},
}
