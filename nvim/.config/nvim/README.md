# 📖 Manual do meu Neovim

Este é o guia de referência para a minha configuração personalizada do Neovim.
**Tema Atual:** Tokyo Night (Night) | **Líder Key:** `Space`

---

## ⌨️ Atalhos Essenciais (Cheat Sheet)

### 🧭 Navegação e Janelas

| Atalho        | Ação                                                   |
| :------------ | :----------------------------------------------------- |
| `<C-h/j/k/l>` | Navegar entre janelas (Esquerda, Baixo, Cima, Direita) |
| `<C-Seta>`    | Redimensionar janelas (Segure Ctrl e use as setas)     |
| `<Leader>e`   | Abrir/Fechar a árvore de arquivos lateral (Neo-tree)   |
| `<Leader>fb`  | Ver lista de buffers (arquivos) abertos                |

### 📂 Gerenciamento de Arquivos

| Atalho       | Ação                                                         |
| :----------- | :----------------------------------------------------------- |
| `<Leader>ff` | **Find Files:** Busca arquivos pelo nome (Telescope)         |
| `<Leader>fg` | **Live Grep:** Busca texto dentro dos arquivos               |
| `:Delete`    | **Custom:** Apaga o arquivo atual do disco (com confirmação) |

### 📝 Edição

| Atalho        | Ação                                          |
| :------------ | :-------------------------------------------- |
| `Esc`         | Limpa o destaque da busca (search highlight)  |
| `J` (Visual)  | Move as linhas selecionadas para baixo        |
| `K` (Visual)  | Move as linhas selecionadas para cima         |
| `<Leader>mp`  | **Make Pretty:** Formata o código manualmente |
| `Salvar (:w)` | Formata o código automaticamente              |

### 🧠 Inteligência (LSP)

_Funciona em: Lua, TS/JS, Python, HTML, CSS, Bash, C, etc._

| Atalho       | Ação                                                              |
| :----------- | :---------------------------------------------------------------- |
| `K`          | **Hover:** Mostra documentação/info sobre o código sob o cursor   |
| `gd`         | **Go to Definition:** Pula para onde a função/variável foi criada |
| `<Leader>rn` | **Rename:** Renomeia a variável em todo o projeto                 |
| `<Leader>ca` | **Code Action:** Sugere correções (ex: importar lib faltante)     |

### 🌳 Árvore de Arquivos (Neo-tree)

_Quando a barra lateral estiver em foco:_

| Tecla   | Ação                           |
| :------ | :----------------------------- |
| `l`     | Abre pasta ou arquivo (Expand) |
| `h`     | Fecha pasta (Collapse)         |
| `Space` | Abre/Fecha pasta               |

---

## 🛠️ Ferramentas Instaladas

### 1. Formatação (Auto-Formatting)

O sistema usa o **Conform.nvim**. A formatação ocorre automaticamente ao salvar (`:w`).

- **Lua:** StyLua
- **Python:** Black + Isort
- **Web (HTML/CSS/JS):** Prettier
- **Shell:** Shfmt
- **Outras (C, Rust, Go, QML):** Usa o formatador nativo do LSP.

### 2. Autocomplete (CMP)

- **Tab:** Próxima sugestão.
- **Shift+Tab:** Sugestão anterior.
- **Enter:** Confirma a sugestão.
- **Fontes:** LSP, Snippets, Buffer (texto atual), Caminhos de arquivo.

### 3. Git (Gitsigns)

Barra lateral esquerda mostra cores: ▎(Adicionado/Modificado),  (Deletado).

| Atalho       | Ação                                                     |
| :----------- | :------------------------------------------------------- |
| `]c`         | Pula para a próxima mudança git no arquivo               |
| `[c`         | Volta para a mudança anterior                            |
| `<Leader>gp` | **Preview:** Mostra janela flutuante com o diff da linha |
| `<Leader>gb` | **Blame:** Mostra quem editou a linha atual              |

---

## ⚙️ Manutenção e Gerenciamento

### Como instalar novos plugins?

1. Edite ou crie um arquivo em `lua/plugins/`.
2. Adicione o bloco do plugin.
3. Salve e reinicie. O `lazy.nvim` instala sozinho.

### Comandos de Gerenciamento

- `:Lazy` -> Abre o painel de plugins (Atualizar, Limpar, Perfil).
- `:Mason` -> Abre o gerenciador de ferramentas (LSP, Formatadores).
  - Use `/` para buscar.
  - Use `i` para instalar.

### Como mudar o tema?

Edite o arquivo `lua/plugins/theme.lua`:

```lua
-- Mude o nome dentro do comando:
vim.cmd.colorscheme("tokyonight-night")
-- Opções instaladas: catppuccin, gruvbox-material, kanagawa, rose-pine
```

### 📂 Estrutura de Pastas

```
~/.config/nvim/
├── init.lua             # Entrada principal (carrega tudo)
├── lazy-lock.json       # Versões exatas dos plugins (não mexer)
├── lua/
│   ├── config/          # Configurações Base
│   │   ├── commands.lua # Meus comandos
│   │   ├── keymaps.lua  # Meus atalhos
│   │   ├── options.lua  # Opções do Vim (números, tabs)
│   │   └── lazy.lua     # Boot do gerenciador de plugins
│   └── plugins/         # Cada arquivo é um plugin ou categoria
│       ├── cmp.lua      # Autocomplete
│       ├── editor.lua   # Neo-tree, Telescope, Treesitter
│       ├── lsp.lua      # Inteligência (Linguagens)
│       ├── formatting.lua # Regras de formatação
│       └── ...
```
