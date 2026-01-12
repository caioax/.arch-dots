return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			-- ========================================================================
			-- 1. CONFIGURAÇÃO VISUAL (Diagnostic) - Versão Moderna (Neovim 0.10+)
			-- ========================================================================
			vim.diagnostic.config({
				-- Texto na linha: DESATIVADO (Limpeza visual)
				virtual_text = false,

				-- Sublinhado no erro: ATIVADO
				underline = true,

				-- Ícones na lateral: ATIVADO (Nova sintaxe sem erro de deprecated)
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "",
					},
				},

				-- Não atualizar enquanto digita
				update_in_insert = false,

				-- Ordenação: Erros graves primeiro
				severity_sort = true,
			})

			-- ========================================================================
			-- 2. DEFINIÇÃO DE ATALHOS GLOBAIS (LspAttach)
			-- ========================================================================
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- === SEU NOVO ATALHO ===
					-- [gl] = Go Line Diagnostic
					map("gl", function()
						vim.diagnostic.open_float({
							scope = "line",
							border = "rounded",
							source = "always",
							header = "",
							prefix = "",
						})
					end, "Ver Erro na Linha (Float)")

					-- Atalhos Padrão
					map("gd", require("telescope.builtin").lsp_definitions, "Go to Definition")
					map("gr", require("telescope.builtin").lsp_references, "Go to References")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("<leader>rn", vim.lsp.buf.rename, "Rename Variable")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action")

					-- Navegação rápida entre erros
					map("[d", function()
						vim.diagnostic.goto_prev({ float = false })
					end, "Erro Anterior")
					map("]d", function()
						vim.diagnostic.goto_next({ float = false })
					end, "Próximo Erro")
				end,
			})

			-- ========================================================================
			-- 3. INICIALIZAÇÃO DO MASON
			-- ========================================================================
			require("mason").setup()

			require("mason-tool-installer").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"html",
					"cssls",
					"bashls",
					"pyright",
					"jsonls",
					"yamlls",
					"stylua",
					"prettier",
					"black",
					"isort",
					"shfmt",
					"eslint_d",
				},
			})

			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ts_ls", "html", "cssls", "bashls", "pyright", "tailwindcss" },
				automatic_installation = true,
				handlers = {
					function(server_name)
						local capabilities = require("cmp_nvim_lsp").default_capabilities()
						require("lspconfig")[server_name].setup({
							capabilities = capabilities,
						})
					end,
				},
			})
		end,
	},
}
