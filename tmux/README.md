# Tmux Cheat Sheet

| Core Config  | Value                              |
| :----------- | :--------------------------------- |
| **Prefix**   | `Ctrl` + `Space`                   |
| **Mouse**    | Enabled (Click, Scroll, Resize)    |
| **Indexes**  | Start at 1 (Windows and Panes)     |
| **Engine**   | Vi Mode + Smart Splits             |

---

## Navigation & Layout (No Prefix)

Quick actions integrated into the keyboard, no need to press the prefix.

| Shortcut                         | Action               | Context                                                          |
| :------------------------------- | :------------------- | :--------------------------------------------------------------- |
| **`Ctrl` + `h j k l`**           | **Navigate (Focus)** | Moves between Tmux splits and Neovim windows seamlessly.         |
| **`Alt` + `h j k l`**            | **Resize**           | Adjusts the size of the current pane (or Neovim split).          |
| **`Ctrl` + `Shift` + `h j k l`** | **Reorder Splits**   | Swaps the current pane with its neighbor (Swap).                 |
| **`Ctrl` + `Alt` + `h l`**       | **Switch Tab**       | Navigates to the previous or next Window (Tab).                  |

---

## Standard Commands (Requires Prefix)

Press `Ctrl`+`Space`, release, then press the key below.

### Pane Management (Splits)

|     Key      | Action           | Description                                         |
| :----------: | :--------------- | :-------------------------------------------------- |
|    **`\|`**  | Vertical Split   | Splits the screen side by side (keeps directory).    |
|    **`-`**   | Horizontal Split | Splits the screen top/bottom (keeps directory).      |
|    **`x`**   | Close            | Closes the current pane (kill-pane).                 |
|    **`z`**   | Zoom             | Maximizes/Restores the current pane.                 |
| **`{` / `}`**| Swap             | Swaps panes (alternative to Ctrl+Shift).             |

### Window Management (Tabs)

|     Key       | Action  | Description                                            |
| :-----------: | :------ | :----------------------------------------------------- |
|    **`c`**    | Create  | New clean tab.                                         |
| **`1` - `9`** | Go to   | Jumps directly to the tab number.                      |
|    **`,`**    | Rename  | Changes the tab name in the status bar.                |
|    **`w`**    | List    | Shows an interactive list of all windows/sessions.     |

### Popups & Tools

|  Key    | Tool                                          |
| :-----: | :-------------------------------------------- |
| **`N`** | Opens the **Neovim** README (Read-Only Mode). |
| **`T`** | Opens this **Tmux** README (Read-Only Mode).  |

---

## Session Persistence

Tmux saves everything automatically every 15 min (Continuum).

| Prefix + Key     | Action                                    |
| :--------------: | :---------------------------------------- |
| **`Ctrl` + `s`** | **Save** state now (Manual).              |
| **`Ctrl` + `r`** | **Restore** last save (Manual).           |
|     **`s`**      | Sessions Menu (Interactive tree).         |
|     **`d`**      | Detach (Exits Tmux, keeps it running).    |

---

## Copy Mode (Vim Style)

1. **`Prefix` + `[`**: Enter the mode.
2. **`v`**: Visual select (select text).
3. **`y`**: Yank (copy to system clipboard).
4. **`q`**: Quit.

---

## Plugins (TPM)

|  Prefix + Key     | Action                                         |
| :---------------: | :--------------------------------------------- |
| **`I`** (shift+i) | **Install** new plugins listed in the conf.    |
| **`U`** (shift+u) | **Update** existing plugins.                   |
|      **`r`**      | **Reload** configuration (`source-file`).      |

### How to add plugins

Edit `~/.tmux.conf` and add to the list:

```tmux
set -g @plugin 'user/plugin'
```

---
