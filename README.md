# Arch Dots

Arch Linux dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/), featuring a Hyprland (Wayland) desktop environment with a custom QuickShell bar and a unified theme system that applies across the entire setup.

## Screenshots

<!-- TODO: Add screenshots for each theme -->
<!--
### Tokyo Night
![Tokyo Night](./assets/tokyonight.png)

### Catppuccin Mocha
![Catppuccin Mocha](./assets/catppuccin.png)

### Dracula
![Dracula](./assets/dracula.png)

### Gruvbox Dark
![Gruvbox Dark](./assets/gruvbox.png)

### Nord
![Nord](./assets/nord.png)

### Rose Pine
![Rose Pine](./assets/rosepine.png)
-->

## Features

- **Hyprland** - Tiling Wayland compositor with modular configuration
- **QuickShell** - Custom QML-based status bar, launcher, notifications, quick settings, and power menu
- **Dynamic Theming** - 6 themes (Tokyo Night, Catppuccin Mocha, Dracula, Gruvbox, Nord, Rose Pine) applied live across the entire system: shell, terminal, editor, wallpaper, and fastfetch logo
- **Neovim** - Lua-based configuration with LSP, Telescope, Smart Splits, and lazy.nvim
- **Tmux** - Terminal multiplexer with seamless Neovim navigation (Smart Splits)
- **Kitty** - GPU-accelerated terminal with dynamic theme switching
- **Zsh** - Oh-My-Zsh with autosuggestions, syntax highlighting, vi-mode, and Powerlevel10k

### Theme System

Switching themes from the Quick Settings panel applies colors instantly to:

| Component | What changes |
| --- | --- |
| QuickShell (bar, launcher, notifications) | All UI colors |
| Kitty | Terminal colors, cursor, tabs, borders |
| Neovim | Colorscheme (sent to all running instances) |
| Hyprland | Active/inactive border colors, shadow |
| Fastfetch | Logo recolored to match accent |
| Wallpaper | Theme-linked wallpaper applied via swww |

No restarts required.

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
| `kitty/`      | Kitty terminal config with dynamic themes                  |
| `zsh/`        | Zsh config with Oh-My-Zsh and Powerlevel10k                |
| `local/`      | Custom scripts (CPU, fans, wallpaper, etc.) and wallpapers |
| `fastfetch/`  | System info display config and dynamic logo                |
| `theming/`    | GTK3/4 and Qt5/6 theme settings                            |
| `kde/`        | KDE Plasma global settings (colors, icons, fonts)          |

### Other Directories

| Directory   | Description                                    |
| ----------- | ---------------------------------------------- |
| `.install/` | Installation scripts and package lists         |
| `.data/`    | Templates, themes, and defaults                |

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

### Wallpapers

Wallpapers are stored in `~/.local/wallpapers/` (git-ignored) and managed through the QuickShell wallpaper picker (`Super + B`). Each theme can have a linked wallpaper that applies automatically on theme switch.

### Adding Themes

Themes are JSON files in `.data/themes/`. Each theme defines colors for the palette, terminal, Hyprland, Neovim, and an optional wallpaper filename. See existing themes for reference.
