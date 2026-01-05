return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- Só carrega quando você abrir um arquivo
	opts = {
		-- Onde salvar as sessões (padrão é ~/.local/state/nvim/sessions)
		-- dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),

		-- Mínimo de buffers abertos para salvar a sessão
		need = 1,

		-- Salvar sessão baseada no branch do git? (Útil se trabalha em várias features)
		branch = true,
	},
	keys = {
		-- Atalho para restaurar a sessão do diretório atual
		{
			"<leader>qs",
			function()
				require("persistence").load()
			end,
			desc = "Restaurar Sessão",
		},

		-- Atalho para restaurar a ÚLTIMA sessão que você usou (qualquer pasta)
		{
			"<leader>ql",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "Restaurar Última Sessão",
		},

		-- Atalho para parar de gravar a sessão atual (útil para coisas rápidas)
		{
			"<leader>qd",
			function()
				require("persistence").stop()
			end,
			desc = "Não Salvar Sessão Atual",
		},
	},
}
