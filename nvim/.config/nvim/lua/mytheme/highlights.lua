local p = require("mytheme.palette")
local M = {}

function M.setup()
	local function hl(group, opts)
		vim.api.nvim_set_hl(0, group, opts)
	end

	-- ========================================================================
	-- 1. INTERFACE GERAL (UI)
	-- ========================================================================
	hl("Normal", { fg = p.fg, bg = p.bg })
	hl("NormalFloat", { fg = p.fg, bg = p.bg_float })
	hl("FloatBorder", { fg = p.border, bg = p.bg_float })

	hl("Cursor", { bg = p.func, fg = p.bg })
	hl("CursorLine", { bg = p.bg_float })
	hl("CursorLineNr", { fg = p.class, bold = true })

	hl("LineNr", { fg = p.fg_dim })
	hl("SignColumn", { bg = "NONE" })
	hl("EndOfBuffer", { fg = p.bg })

	hl("Visual", { bg = p.bg_visual })
	hl("Search", { fg = p.bg, bg = p.number })
	hl("IncSearch", { fg = p.bg, bg = p.class })

	hl("WinSeparator", { fg = p.border })
	hl("VertSplit", { fg = p.border })
	hl("MatchParen", { fg = p.class, bold = true, underline = true })

	-- ========================================================================
	-- 2. SINTAXE (Geral)
	-- ========================================================================
	hl("Comment", { fg = p.fg_dim, italic = true })
	hl("String", { fg = p.string })
	hl("Number", { fg = p.number })
	hl("Boolean", { fg = p.number, bold = true })

	hl("Function", { fg = p.func, bold = true })
	hl("Identifier", { fg = p.fg })

	hl("Keyword", { fg = p.keyword, italic = true })
	hl("Statement", { fg = p.keyword })
	hl("Conditional", { fg = p.keyword })
	hl("Repeat", { fg = p.keyword })

	hl("Operator", { fg = p.fg_dim })
	hl("Type", { fg = p.class })

	hl("Delimiter", { fg = p.fg_dim })

	-- ========================================================================
	-- 3. TREESITTER (A Melhoria Visual)
	-- ========================================================================
	hl("@variable", { fg = p.fg })
	hl("@variable.builtin", { fg = p.keyword })
	hl("@variable.parameter", { fg = p.number })

	hl("@variable.member", { fg = p.property })
	hl("@property", { fg = p.property })

	hl("@function", { fg = p.func, bold = true })
	hl("@function.call", { fg = p.func })
	hl("@function.builtin", { fg = p.func })

	hl("@type", { fg = p.class }) -- Classes (Laranja)
	hl("@type.builtin", { fg = p.class })
	hl("@constructor", { fg = p.class })

	hl("@keyword", { fg = p.keyword, italic = true })
	hl("@keyword.import", { fg = p.keyword, italic = true })

	hl("@tag", { fg = p.class })
	hl("@tag.attribute", { fg = p.property })
	hl("@tag.delimiter", { fg = p.fg_dim })

	hl("@punctuation.delimiter", { fg = p.fg_dim })
	hl("@punctuation.bracket", { fg = p.fg_dim })

	-- ========================================================================
	-- 4. PLUGINS (Menus, Popups e Git)
	-- ========================================================================

	-- Telescope
	hl("TelescopeNormal", { bg = p.bg_dark })
	hl("TelescopeBorder", { fg = p.border, bg = p.bg_dark })
	hl("TelescopePromptNormal", { fg = p.fg, bg = p.bg_float })
	hl("TelescopePromptBorder", { fg = p.func, bg = p.bg_float })
	hl("TelescopePromptTitle", { fg = p.bg, bg = p.func, bold = true })
	hl("TelescopeSelection", { bg = p.bg_visual, fg = p.class })

	-- Pmenu (Autocomplete)
	hl("Pmenu", { bg = p.bg_float, fg = p.fg_dim })
	hl("PmenuSel", { bg = p.bg_visual, fg = p.fg, bold = true })
	hl("PmenuThumb", { bg = p.border })
	hl("CmpItemAbbrMatch", { fg = p.func, bold = true })
	hl("CmpItemKind", { fg = p.class })

	-- GitSigns
	hl("GitSignsAdd", { fg = p.git_add, bg = "NONE" })
	hl("GitSignsChange", { fg = p.git_change, bg = "NONE" })
	hl("GitSignsDelete", { fg = p.git_del, bg = "NONE" })

	-- Diagnostics
	hl("DiagnosticError", { fg = p.diag_err })
	hl("DiagnosticWarn", { fg = p.diag_warn })
	hl("DiagnosticInfo", { fg = p.diag_info })
	hl("DiagnosticHint", { fg = p.diag_hint })
	hl("DiagnosticUnderlineError", { undercurl = true, sp = p.diag_err })

	-- ========================================================================
	-- 5. INDENTAÇÃO (Indent-Blankline / Mini.Indentscope)
	-- ========================================================================

	hl("SnacksIndent", { fg = p.guide }) -- Linhas inativas
	hl("SnacksIndentScope", { fg = p.scope }) -- A linha do bloco atual (Cinza discreto)

	-- ========================================================================
	-- 6. NEO-TREE (Integração Visual)
	-- ========================================================================

	-- Fundo Escuro (Diferencia a árvore do editor de texto)
	hl("NeoTreeNormal", { bg = p.bg_dark, fg = p.fg })
	hl("NeoTreeNormalNC", { bg = p.bg_dark, fg = p.fg })

	-- Remove a linha divisória feia (faz ela ter a cor do fundo escuro)
	hl("NeoTreeWinSeparator", { fg = p.bg_dark, bg = p.bg_dark })
	hl("NeoTreeEndOfBuffer", { fg = p.bg_dark, bg = p.bg_dark })

	-- Navegação
	hl("NeoTreeCursorLine", { bg = p.bg_float, bold = true }) -- Linha selecionada

	-- Elementos
	hl("NeoTreeRootName", { fg = p.fg, bold = true, italic = true }) -- Nome do Projeto
	hl("NeoTreeDirectoryName", { fg = p.func, bold = true }) -- Pastas (Azul)
	hl("NeoTreeDirectoryIcon", { fg = p.func }) -- Ícone de Pasta (Azul)
	hl("NeoTreeFileName", { fg = p.fg }) -- Arquivos normais

	-- Git (Sincronizado com sua paleta)
	hl("NeoTreeGitAdded", { fg = p.git_add })
	hl("NeoTreeGitModified", { fg = p.git_change })
	hl("NeoTreeGitDeleted", { fg = p.git_del })
	hl("NeoTreeGitConflict", { fg = p.error, bold = true })
	hl("NeoTreeGitUntracked", { fg = p.fg_dim, italic = true })

	-- Outros
	hl("NeoTreeIndentMarker", { fg = p.guide }) -- Linhas de guia
	hl("NeoTreeExpander", { fg = p.fg_dim }) -- Seta de abrir/fechar
	hl("NeoTreeSymbolicLinkTarget", { fg = p.property }) -- Symlinks (Ciano)

	-- ========================================================================
	-- 7. SNACKS DASHBOARD
	-- ========================================================================

	-- 1. HEADER (O desenho ASCII)
	hl("SnacksDashboardHeader", { fg = p.func }) -- Azul

	-- 2. MENU (A lista de opções)
	hl("SnacksDashboardIcon", { fg = p.func }) -- Ícone: AZUL (p.func)
	hl("SnacksDashboardDesc", { fg = p.fg }) -- Texto: BRANCO (p.fg)
	hl("SnacksDashboardKey", { fg = p.number, bold = true }) -- Tecla: AMARELO (p.number)

	-- 3. RODAPÉ
	hl("SnacksDashboardFooter", { fg = p.fg_dim }) -- Texto base (Branco escuro)
	hl("SnacksDashboardSpecial", { fg = p.string }) -- Tempo em ms (Verde)
end

return M
