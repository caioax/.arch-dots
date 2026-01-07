return {
	"mrjones2014/smart-splits.nvim",
	lazy = false,
	keys = {
		-- === NAVEGAÇÃO (Ctrl + h/j/k/l) ===
		{
			"<C-h>",
			function()
				require("smart-splits").move_cursor_left()
			end,
			desc = "Mover para Esquerda",
		},
		{
			"<C-j>",
			function()
				require("smart-splits").move_cursor_down()
			end,
			desc = "Mover para Baixo",
		},
		{
			"<C-k>",
			function()
				require("smart-splits").move_cursor_up()
			end,
			desc = "Mover para Cima",
		},
		{
			"<C-l>",
			function()
				require("smart-splits").move_cursor_right()
			end,
			desc = "Mover para Direita",
		},

		-- === REDIMENSIONAMENTO (Alt + h/j/k/l) ===
		{
			"<A-h>",
			function()
				require("smart-splits").resize_left()
			end,
			desc = "Redimensionar Esquerda",
		},
		{
			"<A-j>",
			function()
				require("smart-splits").resize_down()
			end,
			desc = "Redimensionar Baixo",
		},
		{
			"<A-k>",
			function()
				require("smart-splits").resize_up()
			end,
			desc = "Redimensionar Cima",
		},
		{
			"<A-l>",
			function()
				require("smart-splits").resize_right()
			end,
			desc = "Redimensionar Direita",
		},
	},
	config = function()
		require("smart-splits").setup({
			ignored_filetypes = {
				"nofile",
				"quickfix",
				"prompt",
			},
			ignored_buftypes = { "nofile" },
		})
	end,
}
