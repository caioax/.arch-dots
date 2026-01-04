return {
	-- 1. Catppuccin
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },

	-- 2. Tokyo Night
	{ "folke/tokyonight.nvim", lazy = false, priority = 1000 },

	-- 3. Gruvbox Material
	{ "sainnhe/gruvbox-material", lazy = false, priority = 1000 },

	-- 4. Kanagawa
	{ "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },

	-- 5. Rose Pine
	{ "rose-pine/neovim", name = "rose-pine", lazy = false, priority = 1000 },

	-- === BLOCO DE ATIVAÇÃO ===
	{
		"LazyVim/LazyVim", -- (Apenas para garantir que carregue no final)
		config = function()
			-- MUDE O NOME ABAIXO PARA TROCAR O TEMA:
			-- Opções: "catppuccin", "tokyonight", "gruvbox-material", "kanagawa", "rose-pine"

			vim.cmd.colorscheme("tokyonight-night")
		end,
	},
}
