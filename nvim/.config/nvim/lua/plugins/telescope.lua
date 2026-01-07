return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Buscar Arquivos" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Buscar Texto" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Arquivos Abertos" },
	},
	config = function()
		require("telescope").setup({
			defaults = {
				path_display = { "tail" }, -- Mostra apenas o nome do arquivo, esconde o caminho longo
				file_ignore_patterns = { "node_modules", ".git" }, -- Ignora pastas pesadas

				-- === Configuração do preview lateral ==
				sorting_strategy = "ascending", -- Faz a lista começar do topo
				layout_strategy = "horizontal", -- Garante que fique lado a lado
				layout_config = {
					horizontal = {
						prompt_position = "top", -- Barra de pesquisa no topo
						preview_width = 0.6, -- Preview ocupa 60% da largura
					},
					width = 0.85,
					height = 0.85,
				},
			},
		})
	end,
}
