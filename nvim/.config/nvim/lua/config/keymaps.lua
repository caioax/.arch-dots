local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- --- GERAL ---
--- Abrir arquivo de ajuda pessoal
map(
	"n",
	"<leader>",
	":e ~/.config/nvim/README.md<CR>",
	{ noremap = true, silent = true, desc = "Abrir Manual do Neovim" }
)

-- Limpar o destaque da busca (search highlight) apertando Esc
map("n", "<Esc>", ":nohlsearch<CR>", opts)

-- --- NAVEGAÇÃO DE JANELAS (SPLITS) ---

-- Navegar entre janelas com Ctrl + h/j/k/l
map("n", "<C-h>", "<C-w>h", opts) -- Esquerda
map("n", "<C-j>", "<C-w>j", opts) -- Baixo
map("n", "<C-k>", "<C-w>k", opts) -- Cima
map("n", "<C-l>", "<C-w>l", opts) -- Direita

-- Redimensionar com CTRL + Setas
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)
map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)

-- --- EDIÇÃO ---

-- Mover linhas selecionadas para cima/baixo (Modo Visual)
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)
