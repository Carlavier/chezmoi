return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			cpp = { "clang-format" },
			python = { "black" },
			sh = { "shfmt" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescriptreact = { "prettierd" },
			css = { "prettierd" },
			html = { "prettierd" },
		},
		formatters = {
			prettierd = {
				multiple_files = false,
			},
		},
		format_on_save = {
			timeout_ms = 3000,
			lsp_fallback = true,
		},
	},
}
