local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Limpar o destaque da busca (search highlight) apertando Esc
map("n", "<Esc>", ":nohlsearch<CR>", opts)

-- Redimensionar com CTRL + Setas
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)
map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)

-- --- EDIÇÃO ---

-- Mover linhas selecionadas para cima/baixo (Modo Visual)
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)
