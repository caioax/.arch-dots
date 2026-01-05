return {
	"folke/snacks.nvim",
	dependencies = { "echasnovski/mini.icons" },
	priority = 1000,
	lazy = false,
	opts = {
		-- Configurações visuais e utilitários
		bigfile = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		words = { enabled = true },

		-- CONFIGURAÇÃO DO DASHBOARD
		dashboard = {
			enabled = true,
			preset = {
				header = [[
                                                 
        ████ ██████           █████       ██                    
       ███████████              █████                             
       █████████ ███████████████████ ███   ███████████    
      █████████  ███    █████████████ █████ ██████████████    
     █████████ ██████████ █████████ █████ █████ ████ █████    
   ███████████ ███    ███ █████████ █████ █████ ████ █████   
  ██████  █████████████████████ ████ █████ █████ ████ ██████  
                ]],

				-- Botões do Menu
				keys = {
					{ icon = " ", key = "f", desc = "Procurar Arquivo", action = ":Telescope find_files" },
					{ icon = " ", key = "n", desc = "Novo Arquivo", action = ":ene | startinsert" },
					{ icon = " ", key = "g", desc = "Procurar Texto", action = ":Telescope live_grep" },
					{ icon = " ", key = "r", desc = "Arquivos Recentes", action = ":Telescope oldfiles" },
					{
						icon = " ",
						key = "c",
						desc = "Configuração",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{ icon = " ", key = "s", desc = "Restaurar Sessão", section = "session" },
					{ icon = " ", key = "q", desc = "Sair", action = ":qa" },
				},
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "startup" },
			},
		},
	},

	-- (Atalhos Globais) --
	keys = {
		{
			"<leader>sf",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>S",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratch Buffer",
		},
		{
			"<leader>gl",
			function()
				Snacks.lazygit.log_file()
			end,
			desc = "Lazygit Log (cwd)",
		},
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>un",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},
		{
			"<c-/>",
			function()
				Snacks.terminal()
			end,
			desc = "Toggle Terminal",
		},
	},
}
