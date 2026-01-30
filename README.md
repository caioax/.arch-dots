# Arch Dots

Arch Linux dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/), featuring a Hyprland (Wayland) desktop environment with a custom QuickShell bar.

## Features

- **Hyprland** - Tiling Wayland compositor with modular configuration
- **QuickShell** - Custom QML-based status bar, launcher, notifications, quick settings, and power menu
- **Neovim** - Lua-based configuration with LSP, telescope, smart-splits, and lazy.nvim
- **Tmux** - Terminal multiplexer with seamless Neovim navigation (Smart Splits)
- **Kitty** - GPU-accelerated terminal with custom Tokyo Night theme
- **Zsh** - Oh-My-Zsh with autosuggestions, syntax highlighting, vi-mode, and Powerlevel10k

## Quick Start

```bash
git clone https://github.com/caioax/arch-dots.git ~/.arch-dots
cd ~/.arch-dots
./install.sh
```

The installer is interactive and lets you pick which package categories to install. See [.install/README.md](.install/README.md) for advanced usage.

## Structure

Each top-level directory is a [GNU Stow](https://www.gnu.org/software/stow/) package that gets symlinked into `$HOME`.

| Directory     | Description                                                |
| ------------- | ---------------------------------------------------------- |
| `hyprland/`   | Hyprland compositor config (appearance, keybinds, rules)   |
| `quickshell/` | QML shell: bar, launcher, notifications, quick settings    |
| `nvim/`       | Neovim config with lazy.nvim plugin manager                |
| `tmux/`       | Tmux config with TPM and Smart Splits integration          |
| `kitty/`      | Kitty terminal config and color theme                      |
| `zsh/`        | Zsh config with Oh-My-Zsh and Powerlevel10k                |
| `local/`      | Custom scripts (CPU, fans, wallpaper, etc.) and wallpapers |
| `fastfetch/`  | System info display config and custom logo                 |
| `theming/`    | GTK3/4 and Qt5/6 theme settings                            |
| `kde/`        | KDE Plasma global settings (colors, icons, fonts)          |

### Other Directories

| Directory   | Description                                    |
| ----------- | ---------------------------------------------- |
| `.install/` | Installation scripts and package lists         |
| `.data/`    | Templates and defaults copied on first install |

## Tech Stack

| Component       | Tool            |
| --------------- | --------------- |
| Compositor      | Hyprland        |
| Session Manager | UWSM            |
| Shell/Bar       | QuickShell      |
| Terminal        | Kitty           |
| Shell           | Zsh + Oh-My-Zsh |
| Multiplexer     | Tmux            |
| Editor          | Neovim          |
| Wallpaper       | swww            |
| File Manager    | Dolphin         |
| Browser         | Zen Browser     |
| AUR Helper      | yay             |
| Dotfile Manager | GNU Stow        |

## Customization

Machine-specific configs are kept in `hyprland/.config/hypr/local/` and are not tracked by git. The install script generates these from templates in `.data/hyprland/templates/` on first run:

- `monitors.conf` - Monitor layout
- `workspaces.conf` - Workspace mapping
- `extra_environment.conf` - Local environment variables
- `autostart.conf` - Local autostart programs
- `extra_keybinds.conf` - Local keybinds

Wallpapers are stored in `~/.local/wallpapers/` (also git-ignored) and managed through the QuickShell wallpaper picker.
