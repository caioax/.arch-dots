local M = {}

-- ==============================
-- BASE (Fundo e Texto)
-- ==============================
M.bg = "#1a1b26" -- Um azul noturno muito escuro (estilo TokyoNight)
M.bg_dark = "#16161e" -- Para barras laterais e terminais
M.bg_float = "#24283b" -- Para janelas flutuantes
M.bg_visual = "#2e3c64" -- Cor da seleção visual (confortável)

M.fg = "#c0caf5" -- Texto principal (Branco suave, não cansa a vista)
M.fg_dim = "#565f89" -- Comentários e pontuação (Cinza azulado)

M.guide = "#292e42" -- Linhas de indentação inativas (bem escuras)
M.scope = "#444b6a" -- Linha do bloco atual (Cinza discreto)

-- ==============================
-- CORES DE SINTAXE (O "Tempero")
-- ==============================

M.keyword = "#bb9af7" -- ROXO: Import, return, if, function
M.class = "#e0906f" -- LARANJA: Rectangle, Item, Text (Classes)
M.func = "#7aa2f7" -- AZUL: console.log, loops
M.string = "#9ece6a" -- VERDE: "Texto"
M.property = "#7dcfff" -- CIANO: width, height, color (Propriedades de objetos)
M.number = "#e0af68" -- AMARELO: 100, 3.14, true, false
M.error = "#db4b4b" -- VERMELHO: Erros
M.border = "#414868" -- Bordas sutis

-- ==============================
-- GIT & DIAGNOSTICS
-- ==============================

M.git_add = "#9ece6a" -- Verde
M.git_change = "#ffc777" -- Amarelo
M.git_del = "#db4b4b" -- Vermelho

M.diag_err = "#db4b4b"
M.diag_warn = "#e0af68"
M.diag_info = "#ffc777"
M.diag_hint = "#1abc9c"

return M
