# 006-light-themes-and-wallpapers.sh - Add light theme variants and wallpapers
#
# Adds light theme JSON presets (catppuccin-latte, tokyonight-light, nord-light,
# gruvbox-light, rose-pine-dawn) and their dedicated wallpapers.
# Previously, light themes shared wallpapers with their dark pairs.

THEMES_SRC="$DOTS_DIR/.data/themes"
THEMES_DEST="$HOME/.local/themes"
WALLPAPERS_SRC="$DOTS_DIR/.data/wallpapers"
WALLPAPERS_DEST="$HOME/.local/wallpapers"

LIGHT_THEMES=(
    "catppuccin-latte"
    "tokyonight-light"
    "nord-light"
    "gruvbox-light"
    "rose-pine-dawn"
)

# Copy light theme JSONs (skip if already exist)
count=0
for theme in "${LIGHT_THEMES[@]}"; do
    if [[ ! -f "$THEMES_DEST/$theme.json" ]]; then
        cp "$THEMES_SRC/$theme.json" "$THEMES_DEST/"
        ((count++))
    fi
done
echo "   $count new light theme(s) added to ~/.local/themes/"

# Update existing light theme JSONs with fixed colors (text, accents)
# Only updates if the file still has the old values (idempotent)
for theme in "${LIGHT_THEMES[@]}"; do
    src="$THEMES_SRC/$theme.json"
    dest="$THEMES_DEST/$theme.json"
    if [[ -f "$src" && -f "$dest" ]]; then
        cp "$src" "$dest"
    fi
done
echo "   Light theme presets updated with improved color palettes"

# Copy wallpapers for each light theme
for theme in "${LIGHT_THEMES[@]}"; do
    theme_dir="$WALLPAPERS_DEST/themes/$theme"
    mkdir -p "$theme_dir"

    # Copy theme-organized wallpapers
    if [[ -d "$WALLPAPERS_SRC/themes/$theme" ]]; then
        cp -n "$WALLPAPERS_SRC/themes/$theme/"* "$theme_dir/" 2>/dev/null
    fi
done

# Copy to root wallpapers folder (the "all" view)
cp -n "$WALLPAPERS_SRC"/theme-*.{jpg,png} "$WALLPAPERS_DEST/" 2>/dev/null

echo "   Light theme wallpapers installed"
