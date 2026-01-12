local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Limpar o destaque da busca
map("n", "<Esc>", ":nohlsearch<CR>", opts)

-- --- EDIÇÃO ---
-- Mover linhas
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- --- CLIPBOARD & REGISTRADORES ---

-- 1. SISTEMA (Prioridade Total)
-- O comportamento padrão agora é interagir com o Ctrl+C/V do sistema
map({ "n", "v" }, "y", [["+y]]) -- Copia para o sistema
map("n", "Y", [["+Y]])
map({ "n", "v" }, "p", [["+p]]) -- Cola do sistema (substitui texto se estiver no visual)
map({ "n", "v" }, "P", [["+P]]) -- Cola antes do cursor

-- 2. INTERNO "SEGURO" (Com Leader)
-- Usa o registrador "0". Esse registrador só guarda o que você explicitamente COPIOU (y).
-- Ele NUNCA é sujo por coisas que você deletou (dd). É seu "backup" seguro.
map({ "n", "v" }, "<leader>y", [["0y]]) -- Yank Interno (Safe)
map({ "n", "v" }, "<leader>p", [["0p]]) -- Paste Interno (Safe)

-- 3. COLAR DELETADO (Mnemônico: Paste Deleted)
-- Se você deu 'dd' ou 'x', o texto vai para o registrador padrão (").
-- Use esse atalho se quiser recuperar algo que acabou de apagar.
map({ "n", "v" }, "<leader>dp", [[""p]])

-- 4. VISUALIZAR GAVETAS (Telescope)
-- Na dúvida, abra o menu visual para escolher o que colar
map("n", '<leader>"', "<cmd>Telescope registers<cr>", opts)

-- 5. Promover Registrador para o Sistema (Utilitário)
-- <Space> + y + c -> Pergunta qual registrador enviar para o sistema
map("n", "<leader>yc", function()
	local char = vim.fn.input("Qual registrador enviar para o sistema? ")
	if char ~= "" then
		local content = vim.fn.getreg(char)
		if content == "" then
			print(" O registrador '" .. char .. "' está vazio!")
			return
		end
		vim.fn.setreg("+", content)
		print(" Conteúdo de '" .. char .. "' enviado para o Clipboard!")
	end
end, opts)
