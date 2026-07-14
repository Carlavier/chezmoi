return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"DrKJeff16/project.nvim",
	},
	keys = {
		{ "<leader>sf", desc = "Search Files" },
		{ "<leader>sg", desc = "Search by Grep" },
		{ "<leader>sb", desc = "Search Buffers" },
		{ "<leader>sh", desc = "Search Help" },
		{ "<leader>sk", desc = "Search Keymaps" },
		{ "<leader>sc", desc = "Search Commands" },
		{ "<leader>si", desc = "Search Git Files" },
		{ "<leader>sp", desc = "Search Projects" },
		{ "<leader>sn", desc = "Search Neovim Config" },
	},
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		local function folder_icon_entry_maker(opts)
			opts = opts or {}
			local devicons = require("nvim-web-devicons")
			local entry_display = require("telescope.pickers.entry_display")

			local displayer = entry_display.create({
				separator = " ",
				items = {
					{ width = 2 },
					{ remaining = true },
				},
			})

			return function(line)
				if line == "" then
					return nil
				end

				local absolute_path = line
				local is_abs = line:sub(1, 1) == "/" or line:match("^%a+:")
				if opts.cwd and not is_abs then
					absolute_path = vim.fs.joinpath(opts.cwd, line)
				end

				local entry = {
					value = line,
					ordinal = line,
					path = absolute_path,
				}

				entry.display = function(et)
					local icon, icon_highlight

					if vim.fn.isdirectory(et.path) == 1 then
						icon = ""
						icon_highlight = "DevIconDefault"
					else
						local filename = vim.fs.basename(et.path)
						local ext = vim.fn.fnamemodify(filename, ":e")
						icon, icon_highlight = devicons.get_icon(filename, ext, { default = true })
					end

					return displayer({
						{ icon, icon_highlight },
						et.value,
					})
				end

				return entry
			end
		end

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
					builtin.find_files({
						cwd = path,
						entry_maker = folder_icon_entry_maker({ cwd = path }),
					})
				end)
			else
				actions.select_default(prompt_bufnr)
			end
		end

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
			lsp = {
				enabled = true,
				use_pattern_matching = false,
			},
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
					n = {},
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

		local find_files_with_dynamic_cwd = function()
			local current_cwd = vim.fn.getcwd()
			builtin.find_files({
				cwd = current_cwd,
				entry_maker = folder_icon_entry_maker({ cwd = current_cwd }),
			})
		end

		vim.keymap.set("n", "<leader>sf", find_files_with_dynamic_cwd, { desc = "Search Files" })
		vim.keymap.set("n", "<leader>[", find_files_with_dynamic_cwd)
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Search by Grep" })
		vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Search Buffers" })
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search Help" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search Keymaps" })
		vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "Search Commands" })
		vim.keymap.set("n", "<leader>si", builtin.git_files, { desc = "Search Git Files" })
		vim.keymap.set("n", "<leader>sp", function()
				telescope.extensions.projects.projects({
					attach_mappings = function(_, map)
						map({ "i", "n" }, "<CR>", open_with_oil)
						return true
					end,
				})
			end,
			{ desc = "Search Projects" })

		vim.keymap.set("n", "<leader>sn", function()
			local config_path = vim.fn.stdpath("config")
			builtin.find_files({
				cwd = config_path,
				find_command = { "fdfind", "--type", "f", "--type", "d", "--hidden", "--strip-cwd-prefix" },
				entry_maker = folder_icon_entry_maker({ cwd = config_path }),
			})
		end, { desc = "Search Neovim Config" })
	end,
}
