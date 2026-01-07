return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- 1. Importamos paleta
		local p = require("mytheme.palette")
		vim.api.nvim_set_hl(0, "StatusLine", { bg = p.bg_dark, fg = p.fg })
		vim.api.nvim_set_hl(0, "StatusLineNC", { bg = p.bg_dark, fg = p.fg_dim })

		-- 2. Criando o tema da Lualine
		local custom_theme = {
			normal = {
				a = { bg = p.func, fg = p.bg, gui = "bold" }, -- Modo Normal (Azul)
				b = { bg = p.bg_float, fg = p.fg }, -- Branch/Git
				c = { bg = p.bg_dark, fg = p.fg_dim }, -- Nome do arquivo (Fundo escuro)
			},
			insert = {
				a = { bg = p.string, fg = p.bg_dark, gui = "bold" }, -- Modo Insert (Verde)
				b = { bg = p.bg_float, fg = p.fg },
				c = { bg = p.bg_dark, fg = p.fg_dim },
			},
			visual = {
				a = { bg = p.class, fg = p.bg_dark, gui = "bold" }, -- Modo Visual (Laranja)
				b = { bg = p.bg_float, fg = p.fg },
				c = { bg = p.bg_dark, fg = p.fg_dim },
			},
			replace = {
				a = { bg = p.error, fg = p.bg, gui = "bold" }, -- Modo Replace (Vermelho)
				b = { bg = p.bg_float, fg = p.fg },
				c = { bg = p.bg_dark, fg = p.fg_dim },
			},
			command = {
				a = { bg = p.number, fg = p.bg, gui = "bold" }, -- Modo Comando (Amarelo)
				b = { bg = p.bg_float, fg = p.fg },
				c = { bg = p.bg_dark, fg = p.fg_dim },
			},
			inactive = {
				a = { bg = p.bg_dark, fg = p.fg_dim, gui = "bold" },
				b = { bg = p.bg_dark, fg = p.fg_dim },
				c = { bg = p.bg_dark, fg = p.fg_dim },
			},
		}

		-- 3. Configuração
		require("lualine").setup({
			options = {
				theme = custom_theme,
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
			},
			sections = {
				lualine_a = {
					{ "mode", separator = { left = "" }, right_padding = 2 },
				},
				lualine_b = {
					"branch",
					{ "diff", colored = true },
				},
				lualine_c = {
					{ "filename", path = 1 },
				},
				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = " ", warn = " ", info = " " },
						diagnostics_color = {
							error = { fg = p.diag_err },
							warn = { fg = p.diag_warn },
							info = { fg = p.diag_info },
						},
					},
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = {
					{ "location", separator = { right = "" }, left_padding = 2 },
				},
			},
		})
	end,
}
