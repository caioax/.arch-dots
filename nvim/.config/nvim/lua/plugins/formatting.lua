return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" }, -- Carrega antes de salvar
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Atalho manual para formatar: Leader + mp
        "<leader>mp",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Formatar buffer atual",
      },
    },
    -- AQUI ESTÁ A CONFIGURAÇÃO QUE FALTAVA NO BLOCO CORRETO
    config = function()
      require("conform").setup({
        -- Define quais formatadores usar para cada linguagem
        formatters_by_ft = {
          lua = { "stylua" },

          -- Python
          python = { "isort", "black" },

          -- Web (Prettier para tudo)
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },

          -- Shell
          sh = { "shfmt" },
          bash = { "shfmt" },
        },

        -- Configura o Format on Save
        format_on_save = {
          -- Se não tiver formatador (ex: C++, Rust), usa o LSP nativo
          lsp_fallback = true,
          async = false,
          timeout_ms = 500,
        },
      })
    end,
  },
}
