#!/bin/bash
# =============================================================================
# Wallpaper Boot Script
# =============================================================================
# Applies the persistent wallpaper on boot using swww.
# Reads the wallpaper path from ~/.local/wallpapers/.current
# =============================================================================

CURRENT_FILE="$HOME/.local/wallpapers/.current"
WALLPAPER_DIR="$HOME/.local/wallpapers"

# Read the saved wallpaper
if [[ -f "$CURRENT_FILE" ]]; then
    WALLPAPER="$(cat "$CURRENT_FILE")"
fi

# Fallback: if file doesn't exist or the referenced wallpaper doesn't exist
if [[ -z "$WALLPAPER" || ! -f "$WALLPAPER" ]]; then
    WALLPAPER="$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -name '*.png' -o -name '*.jpg' -o -name '*.jpeg' -o -name '*.webp' \) | head -1)"
fi

if [[ -n "$WALLPAPER" && -f "$WALLPAPER" ]]; then
    swww img "$WALLPAPER" \
        --transition-type grow \
        --transition-duration 1 \
        --transition-fps 60 \
        --transition-step 90
fi
