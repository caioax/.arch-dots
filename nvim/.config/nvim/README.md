# ⚡ Neovim Cheat Sheet

| Core Config        | Value                     |
| :----------------- | :------------------------ |
| **Leader Key**     | `Space`                   |
| **Plugin Manager** | `lazy.nvim`               |
| **LSP/Format**     | `Mason` + `Conform`       |
| **Engine**         | `Smart Splits` + `Snacks` |

---

## 🧭 Navigation & Windows (Smart Splits)

Seamless integration with Tmux. Does not require Leader.

| Shortcut               | Action         | Description                                          |
| :--------------------- | :------------- | :--------------------------------------------------- |
| **`Ctrl` + `h j k l`** | **Navigate**   | Moves focus between Vim splits and Tmux panes.       |
| **`Alt` + `h j k l`**  | **Resize**     | Increases/Decreases the size of the current split.   |

---

## 📋 Clipboard & Copy/Paste

Workflow for Yank and system Clipboard

| Shortcut            | Action               | Description                                                                |
| :------------------ | :------------------- | :------------------------------------------------------------------------- |
| **`y`** / **`p`**   | **Internal (Safe)**  | `p` always pastes the last **Yank** (`0`), ignoring recent deletes.        |
| **`Space` + `y`**   | Copy to System       | Copies the selection to the **System** clipboard (Ctrl+V works outside).   |
| **`Space` + `p`**   | Paste from System    | Pastes content from the **System** clipboard.                              |
| **`Space` + `d`**   | Paste Deleted        | Pastes what was actually deleted/cut (`dd` / `x` etc).                     |
| **`Space` + `"`**   | **View Registers**   | Opens a visual menu (`Telescope`) with copy history.                       |
| **`Space` + `y c`** | Export               | Sends a specific register (`0`, `a`...) to the System.                     |

---

## ⌨️ Leader Commands (`Space` + Key)

### 📂 Files and Search (Telescope)

| Shortcut  | Action     | Description                                    |
| :-------: | :--------- | :--------------------------------------------- |
| **`f f`** | Find Files | Searches files by name (ignores gitignore).    |
| **`f g`** | Live Grep  | Searches for text inside all files.            |
| **`f b`** | Buffers    | Lists open files in memory.                    |
|  **`e`**  | Explorer   | Opens/Closes the side tree (`NeoTree`).        |

### 🛠️ Tools (Snacks.nvim)

|      Shortcut     | Action         | Description                                |
| :--------------: | :------------- | :----------------------------------------- |
|    **`l g`**     | **LazyGit**    | Opens floating Git graphical interface.    |
|    **`g l`**     | Git Log        | Commit history of the current file.        |
|    **`s f`**     | Scratch        | Floating temporary notepad.                |
|     **`S`**      | Select Scratch | Selects among saved temporary notes.       |
|    **`u n`**     | Dismiss        | Clears all notifications from the screen.  |
| **`Ctrl` + `/`** | Terminal       | Opens/Closes quick floating terminal.      |

### 💾 Sessions (Persistence)

Neovim saves sessions automatically.

| Shortcut  | Action       | Description                                  |
| :-------: | :----------- | :------------------------------------------- |
| **`q s`** | Restore Dir  | Restores the session of the current folder.  |
| **`q l`** | Restore Last | Restores the last global session used.       |
| **`q d`** | Stop         | Stops recording the current session.         |

---

## 🧠 Code and Intelligence (LSP)

Shortcuts available when a code file is open.

### ⚡ Quick Actions

| Shortcut  | Command     | Description                                          |
| :-------: | :---------- | :--------------------------------------------------- |
|  **`K`**  | Hover       | Opens documentation of the function under the cursor.|
| **`g d`** | Definition  | Jumps to the variable/function definition.           |
| **`r n`** | Rename      | Renames variable across the entire project.          |
| **`c a`** | Code Action | Quick fix menu (Fix/Import).                         |
| **`m p`** | **Format**  | Formats the file (`Conform`: Prettier/Stylua).       |

### 🤖 Autocomplete (CMP)

|        Key           | Action                                                    |
| :------------------: | :-------------------------------------------------------- |
| **`Ctrl` + `Space`** | Forces the suggestions menu to appear.                    |
|      **`Tab`**       | Next suggestion / Jumps to next snippet field.            |
|     **`Enter`**      | Confirms the selected suggestion.                         |

### 📝 Git (Gitsigns)

| Shortcut  | Action                                                       |
| :-------: | :----------------------------------------------------------- |
| **`] c`** | Jumps to the next change (Hunk).                             |
| **`[ c`** | Jumps to the previous change.                                |
| **`g p`** | **Preview**: Shows what changed on the current line (popup). |
| **`g b`** | **Blame**: Shows who edited the current line.                |

---

## ⚙️ Maintenance and Installation

### Folder Structure

```text
~/.config/nvim/
├── init.lua            # Boot
├── lazy-lock.json      # Locked versions (Don't touch)
├── lua/
│   ├── config/         # Options, Keymaps, Commands
│   ├── mytheme/        # Your local theme (Palette/Highlights)
│   └── plugins/        # Modules (LSP, Snacks, CMP, etc)
```

### How to install...

**1. New Plugins:**
Create a file at `lua/plugins/name.lua` and paste the `return { ... }` code. `lazy` installs automatically on restart.

**2. New Languages (LSP/Formatters):**

1. Type `:Mason`.
2. Search with `/` (e.g.: `python`, `gopls`).
3. Press `i` to install.
4. **Required:** Add to the `ensure_installed` list in:
   - `lua/plugins/lsp.lua` (for Servers)
   - `lua/plugins/formatting.lua` (for Formatters)

**3. Updates:**

- Update Plugins: `:Lazy sync`
- Update Tools: `:MasonUpdate`
- Reload Theme: `<Space>rt` (Reload Theme)
