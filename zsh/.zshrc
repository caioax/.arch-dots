# === SMART TMUX START ===
# Verifica se o tmux está instalado e se não estamos já dentro de uma sessão
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    # Define o nome da sessão principal
    SESSION_NAME="main"

    # Verifica se a sessão 'main' existe
    if tmux has-session -t $SESSION_NAME 2>/dev/null; then
        # Verifica se a sessão 'main' já tem alguém conectado (attached)
        if tmux list-sessions | grep -q "^$SESSION_NAME.*(attached)"; then
            # Se já está aberta em outro lugar, cria uma nova sessão independente
            ID=1
            while tmux has-session -t $ID 2>/dev/null; do
                ((ID++))
            done 
            exec tmux new-session -s $ID
        else
            # Se existe mas ninguém está usando, conecta nela
            exec tmux attach-session -t $SESSION_NAME
        fi
    else
        # Se a sessão 'main' não existe, cria ela
        exec tmux new-session -s $SESSION_NAME
    fi
fi

# === POWERLEVEL10K INSTANT PROMPT ===
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# === OMZ CONFIGURATION ===
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# --- Tmux Plugin Settings ---
ZSH_TMUX_AUTOSTART=false
ZSH_TMUX_AUTOCONNECT=false
ZSH_TMUX_DEFAULT_SESSION_NAME="main"
ZSH_TMUX_UNICODE=true

# --- Plugins List ---
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-vi-mode tmux)

source $ZSH/oh-my-zsh.sh

# === EDITOR SETTINGS ===
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# === CUSTOM FIXES & INTEGRATIONS ===

# Clipboard Fix
function zvm_vi_yank() {
    zvm_yank
    echo -n "${CUTBUFFER}" | wl-copy
}

# Configurações do Vi-Mode
ZVM_CURSOR_STYLE_ENABLED=true
autoload -U edit-command-line
zle -N edit-command-line

function zvm_after_init() {
  # Ctrl+v abre o comando atual no Neovim para editar
  zvm_bindkey vicmd '^V' edit-command-line
  zvm_bindkey viins '^V' edit-command-line
}

# === ALIASES ===
alias all-update='sudo pacman -Syu && yay -Syu && flatpak update'

# Dotfiles Management
alias dots='git -C ~/.arch-dots'

# === FUNCTIONS ===

# Dots Save Helper
function dots-save() {
    local GREEN='\033[1;32m'
    local BLUE='\033[1;34m'
    local YELLOW='\033[1;33m'
    local RED='\033[0;31m'
    local NC='\033[0m' 

    if [ -z "$1" ]; then
        echo "${RED} Error: You must provide a commit message.${NC}"
        echo "   Usage: dots-save \"Your message here\""
        return 1
    fi

    local DOTS_DIR="$HOME/.arch-dots"

    echo ""
    echo "${BLUE}󰏔  Starting DOTFILES synchronization...${NC}"
    echo "----------------------------------------"
    echo "${YELLOW}1. Checking changes and staging files...${NC}"
    
    if [[ -n $(git -C "$DOTS_DIR" status --porcelain) ]]; then
        git -C "$DOTS_DIR" status --short | sed 's/^/   /' 
        git -C "$DOTS_DIR" add .
        echo "${GREEN}    Files staged successfully.${NC}"
    else
        echo "${GREEN}    Directory clean (no new changes found).${NC}"
    fi

    if ! git -C "$DOTS_DIR" diff --cached --quiet; then
        echo ""
        echo "${YELLOW}2. Creating commit...${NC}"
        git -C "$DOTS_DIR" commit -m "$1" | sed 's/^/   /' 
        echo "${GREEN}    Commit created: '$1'${NC}"
    else
        echo ""
        echo "${YELLOW}2. Skipping commit (nothing new to commit).${NC}"
    fi

    echo ""
    echo "${YELLOW}3. Pushing to remote repository...${NC}"
    if git -C "$DOTS_DIR" push; then
        echo ""
        echo "----------------------------------------"
        echo "${GREEN}󰄬 SUCCESS! Dotfiles are synced and secure.${NC}"
        echo ""
    else
        echo ""
        echo "${RED} FAILED to push. Check network or conflicts.${NC}"
        return 1
    fi
}

# === FINALIZERS ===
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH=$PATH:/home/caio/.spicetify
