return {
	"mytheme",
	dir = vim.fn.stdpath("config"),
	lazy = false,
	priority = 1000,
	config = function()
		-- 1. Setup Inicial
		vim.cmd("hi clear")
		if vim.fn.exists("syntax_on") then
			vim.cmd("syntax reset")
		end
		vim.o.termguicolors = true
		vim.g.colors_name = "mytheme"

		-- 2. Carrega o tema
		require("mytheme.highlights").setup()

		-- ============================================================
		-- FERRAMENTA DE RECARREGAMENTO (Hot Reload)
		-- ============================================================
		-- Comando :ReloadTheme
		vim.api.nvim_create_user_command("ReloadTheme", function()
			-- 1. Limpa o cache dos módulos do seu tema
			package.loaded["mytheme.palette"] = nil
			package.loaded["mytheme.highlights"] = nil

			-- 2. Recarrega os módulos limpos
			require("mytheme.highlights").setup()

			-- 3. Força a atualização da Lualine
			if package.loaded["lualine"] then
				require("lualine").refresh()
			end

			print("Theme reloaded successfully!")
		end, {})

		-- Atalho: <leader>rt (Reload Theme)
		vim.keymap.set("n", "<leader>rt", "<cmd>ReloadTheme<cr>", { desc = "Reload Theme" })
	end,
}
