# Install lyne CLI script to ~/.local/bin
# This replaces the old zsh function with a standalone bash script

local LYNE_SRC="$DOTS_DIR/local/.local/bin/lyne"
local LYNE_BIN="$HOME/.local/bin/lyne"

mkdir -p "$HOME/.local/bin"
ln -sf "$LYNE_SRC" "$LYNE_BIN"
echo "   Installed lyne CLI to $LYNE_BIN"
