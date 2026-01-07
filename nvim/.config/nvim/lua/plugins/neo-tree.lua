return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Explorer (Toggle)" },
	},
	config = function()
		require("neo-tree").setup({
			-- Remove a borda padrão para criar o efeito de "Barra Lateral" limpa
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,

			-- Configuração Visual
			default_component_configs = {
				indent = {
					with_expanders = true, -- Mostra setinhas
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				git_status = {
					symbols = {
						-- Ícones mais limpos para o Git
						added = "✚",
						modified = "",
						deleted = "✖",
						renamed = "󰁕",
						untracked = "",
						ignored = "",
						unstaged = "󰄱",
						staged = "",
						conflict = "",
					},
				},
			},

			window = {
				position = "left",
				width = 30,
				mappings = {
					["l"] = "open",
					["h"] = "close_node",
					["<space>"] = "none",
					-- Atalhos extras úteis
					["Y"] = {
						function(state)
							local node = state.tree:get_node()
							local path = node:get_id()
							vim.fn.setreg("+", path, "c")
						end,
						desc = "Copy Absolute Path",
					},
				},
			},

			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true, -- Atualiza auto se mudar fora do nvim
			},
		})
	end,
}
