# === 1. POWERLEVEL10K INSTANT PROMPT ===
# This must remain at the top for performance
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# === 2. VISUAL FETCH ===
# Show fastfetch only in the first Kitty instance
if [[ $(pgrep -cx kitty) -le 1 ]] && command -v fastfetch >/dev/null 2>&1; then
  fastfetch
fi

# === 3. AUTO-INSTALLATION LOGIC (PORTABLE) ===
export ZSH="$HOME/.oh-my-zsh"

# Ensure Oh My Zsh is installed
if [[ ! -d "$ZSH" ]]; then
  echo "Oh My Zsh not found. Cloning repository..."
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$ZSH"
fi

# Clone missing plugins and themes
ZSH_CUSTOM_DIR="$ZSH/custom"
DEPENDENCIES=(
  "https://github.com/zsh-users/zsh-autosuggestions|plugins/zsh-autosuggestions"
  "https://github.com/zsh-users/zsh-syntax-highlighting|plugins/zsh-syntax-highlighting"
  "https://github.com/jeffreytse/zsh-vi-mode|plugins/zsh-vi-mode"
  "https://github.com/romkatv/powerlevel10k|themes/powerlevel10k"
)

for item in "${DEPENDENCIES[@]}"; do
  URL="${item%%|*}"
  DEST="${item##*|}"
  if [[ ! -d "$ZSH_CUSTOM_DIR/$DEST" ]]; then
    echo "Installing dependency: $DEST"
    git clone --depth=1 "$URL" "$ZSH_CUSTOM_DIR/$DEST"
  fi
done

# === 4. OH MY ZSH CONFIGURATION ===
ZSH_THEME="powerlevel10k/powerlevel10k"

# Tmux Plugin Settings
ZSH_TMUX_AUTOSTART=false
ZSH_TMUX_AUTOCONNECT=false
ZSH_TMUX_DEFAULT_SESSION_NAME="main"
ZSH_TMUX_UNICODE=true

# Plugins List
plugins=(
  git 
  zsh-autosuggestions 
  zsh-syntax-highlighting 
  zsh-vi-mode
)

# Initialize Oh My Zsh
source $ZSH/oh-my-zsh.sh

# === 5. ENVIRONMENT VARIABLES ===
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Path management (Portable)
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.spicetify"

# === 6. CUSTOM FUNCTIONS & VI-MODE FIXES ===

# Clipboard Fix for Wayland (Hyprland)
function zvm_vi_yank() {
    zvm_yank
    echo -n "${CUTBUFFER}" | wl-copy
}

# Vi-Mode Configuration
ZVM_CURSOR_STYLE_ENABLED=true
autoload -U edit-command-line
zle -N edit-command-line

function zvm_after_init() {
  # Ctrl+v opens current command in Neovim
  zvm_bindkey vicmd '^V' edit-command-line
  zvm_bindkey viins '^V' edit-command-line
}

# === 7. ALIASES ===
alias all-update='sudo pacman -Syu && yay -Syu && flatpak update'
alias dots='git -C ~/.arch-dots'

# === 8. FINALIZERS ===
# Load Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
