# Dotfiles by Rizauddin Saian

This repository contains my personal configuration files (dotfiles) for **Zsh**, **Vim**, **Neovim**, and **Ranger**, designed for a macOS + Homebrew environment.  
All files are managed using **[GNU Stow](https://www.gnu.org/software/stow/)** to keep them portable and easy to maintain.

---

## Repository Structure

```
~/.dotfiles
├── zsh/
│   └── .zshrc                          # Shell configuration
├── vim/
│   └── .vimrc                          # Vim configuration
├── nvim/
│   └── .config/nvim/init.lua           # Neovim configuration (lazy.nvim)
├── ranger/
│   └── .config/ranger/                 # Ranger configuration
└── README.md
```

Each folder mirrors your `$HOME` layout. Stow creates symlinks from these folders to the actual config files in your home directory.

---

## Using GNU Stow

### 1) Install Stow (macOS)
```bash
brew install stow
```

### 2) Clone this repo
```bash
git clone git@github.com:rizauddin/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 3) Deploy (symlink) configuration files
```bash
stow -v zsh vim nvim ranger
```

This will create:
```
~/.zshrc               → ~/.dotfiles/zsh/.zshrc
~/.vimrc               → ~/.dotfiles/vim/.vimrc
~/.config/nvim/init.lua→ ~/.dotfiles/nvim/.config/nvim/init.lua
~/.config/ranger/      → ~/.dotfiles/ranger/.config/ranger/
```

> If `~/.config/nvim/init.lua` already exists, move it first:
> ```bash
> mkdir -p ~/.dotfiles/nvim/.config/nvim
> mv ~/.config/nvim/init.lua ~/.dotfiles/nvim/.config/nvim/
> stow -v nvim
> ```

### 4) Remove symlinks
```bash
stow -D zsh vim nvim ranger
```

### 5) Reapply symlinks
```bash
stow -R zsh vim nvim ranger
```

---

## Zsh Configuration

Feature-rich shell with sensible defaults.

**Highlights**
- Oh My Zsh + Powerlevel10k
- Syntax highlighting & autosuggestions
- `zoxide` smart cd
- PATH setup for Homebrew, Java, Flutter/Dart, Android SDK, Python, R
- Convenience aliases (e.g. radio via `mpv`, Chrome profiles)

**Setup**
```bash
# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k
brew install romkatv/powerlevel10k/powerlevel10k
p10k configure

# Apply
source ~/.zshrc
```

---

## Vim Configuration

Optimised for LaTeX, HTML, JS/TS, and Markdown. Uses **vim-plug**.

**Plugins**
- `lervag/vimtex` (LaTeX)
- `junegunn/fzf` + `fzf.vim` (finder)
- `preservim/nerdtree` (file tree)
- `neoclide/coc.nvim` (LSP/completion)
- `mattn/emmet-vim` (HTML)
- `tpope/vim-commentary` (comments)
- `prettier/vim-prettier` (format)
- `iamcco/markdown-preview.nvim` (preview)
- `morhetz/gruvbox` (theme)
- `ludovicchabant/vim-gutentags` (ctags)

**Useful**
- Dark Gruvbox, relative numbers, smart search
- HTML/JSX/TSX/GraphQL syntax
- `:PrettyJSON` for JSON
- Tags with `ctags`

**Common commands**

| Command | Mode | Description |
|---|---|---|
| `\ll` | Normal | Compile LaTeX (VimTeX) |
| `\lv` | Normal | Open PDF in Skim |
| `:Files` / `<leader>f` | Normal | FZF files |
| `<leader>n` | Normal | Toggle NERDTree |
| `:PrettyJSON` | Cmd | Format JSON |

**Install plugins**
```bash
vim +PlugInstall +qall
```

---

## Neovim Configuration

A Lua-first setup that mirrors the Vim experience but uses modern plugins.

**Location**
```
~/.dotfiles/nvim/.config/nvim/init.lua
```

**Manager**
- **lazy.nvim** (bootstraps itself)

**Key Plugins**
- Theme: `morhetz/gruvbox`, `sainnhe/gruvbox-material`
- Finder: **Telescope** (`nvim-telescope/telescope.nvim`)
  - `<leader>f` files, `<leader>b` buffers, `<leader>g` live grep, `<leader>w` in-buffer fuzzy
- Comments: `numToStr/Comment.nvim`
- Markdown preview: `iamcco/markdown-preview.nvim`
- Formatting: `stevearc/conform.nvim` (Prettier where relevant)
- Treesitter: `nvim-treesitter/nvim-treesitter` (JS/TS/JSX/GraphQL/Markdown/etc.)
- LaTeX: `lervag/vimtex` with **Skim** viewer and `latexmk`
- Copilot: `github/copilot.vim`
- Emmet: `mattn/emmet-vim`
- Tags: `ludovicchabant/vim-gutentags` (`ctags`)

**Editor behaviour**
- Dark background, termguicolors
- Relative numbers, cursorline
- Search: `ignorecase` + `smartcase`
- Indent: 2 spaces
- `clipboard=unnamedplus` (pastes from macOS clipboard by default)  
  - Paste last yank (ignoring clipboard): `"0p`
- Arrow keys show hints to use `hjkl` (like Vim setup)

**Neovim setup steps**
```bash
# Open Neovim and run (lazy.nvim will bootstrap):
nvim

# Then:
:checkhealth
:Lazy sync
:TSUpdate
```

**Extra commands provided**
- `:PrettyJSON` — format JSON
- `:LatexClean` — remove LaTeX aux/out
- `:LatexDoctor` — check Skim + nvr + latexmk + vimtex wiring
- `:ReloadConfig` — reload `init.lua`

**Skim + inverse search notes**
- Uses a fixed Neovim RPC socket for reliable inverse search via `nvr`.
- In Skim ▸ Preferences ▸ Sync:  
  Command: `/opt/homebrew/bin/nvr`  
  Args: `--server /tmp/nvim-riza --remote-silent +"%line" "%file"`

**Telescope vs FZF**
- Vim uses **FZF**.
- Neovim uses **Telescope** (richer integration with Lua ecosystem).

---

## Ranger Configuration

Ranger is a terminal-based file manager that integrates well with Zsh and Neovim.  
This setup is **macOS-first**, using **Preview.app** for images/PDFs and `open` for Office files.

**Location**
```
~/.dotfiles/ranger/.config/ranger/
├── rc.conf        # Ranger settings and keymaps
├── rifle.conf     # File opener rules (macOS friendly)
└── scope.sh       # Preview script
```

---

### Features

- macOS integration (`open` and Preview.app)  
- Quick Look with `q` (`qlmanage -p`)  
- Trash instead of permanent delete (`trash -F`)  
- Image and PDF previews (Kitty / iTerm2)  
- Devicons for file icons  
- Seamless **zoxide** integration for fast directory jumping  

---

### Installation

```bash
brew install ranger trash bat glow exiftool ffmpegthumbnailer poppler
```

Optional (for previews):
```bash
brew install kitty   # or use iTerm2 with preview_images_method iterm2
```

Deploy with stow:
```bash
cd ~/.dotfiles
stow -v ranger
```

This will create:
```
~/.config/ranger/rc.conf
~/.config/ranger/rifle.conf
~/.config/ranger/scope.sh
```

---

### Key Mappings

| Key | Action |
|-----|--------|
| `Enter` | Open file using `rifle.conf` rules |
| `q` | Quick Look preview |
| `h` / `l` | Navigate left / right |
| `dd` | Move to Trash |
| `gz` | Jump to directory using zoxide |

---

### Notable Config Highlights

**rc.conf**
```ini
set draw_borders true
set show_hidden true
set confirm_on_delete never
set use_preview_script true
set preview_images true
set preview_images_method iterm2  # or kitty
map q shell -w qlmanage -p -- "%s" >/dev/null 2>&1
map gz console z
```

**rifle.conf** (simplified)
```conf
mime ^image,           X, flag f = open -a "Preview" -- "$@"
ext pdf,               X, flag f = open -a "Preview" -- "$@"
ext doc|docx|xls|ppt|csv, X, flag f = open -- "$@"
mime ^text,            flag f = ${VISUAL:-${EDITOR:-nvim}} -- "$@"
label quicklook,       flag f = qlmanage -p "$@" >/dev/null 2>&1
```

---

### Zoxide Integration

You can use **zoxide** directly inside Ranger to jump to frequently visited directories.

1. Install zoxide:
   ```bash
   brew install zoxide
   echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
   ```
2. Add this to `~/.config/ranger/commands.py`:
   ```python
   from ranger.api.commands import Command
   import subprocess

   class z(Command):
       """:z [query] — jump using zoxide"""
       def execute(self):
           query = self.arg(1) if self.arg(1) else None
           try:
               target = subprocess.check_output(
                   ['zoxide', 'query', query or '-i'], text=True).strip()
               self.fm.cd(target)
           except subprocess.CalledProcessError:
               self.fm.notify("No match found.", bad=True)
   ```
3. Restart Ranger and try:
   ```
   :z projects
   ```
   or just `:z` for interactive mode.

---

### Optional Enhancements

- **Devicons**
  ```bash
  git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
  echo "default_linemode devicons" >> ~/.config/ranger/rc.conf
  ```
- **Zsh alias**
  ```zsh
  alias r='ranger'
  ```

---

### Troubleshooting

- **“method 0 is undefined”** → invalid `rifle.conf` syntax. Use the version above.  
- **Office files open only with `o`** → missing `ext` rule in `rifle.conf`.  
- **No previews** → ensure `scope.sh` is executable and preview options are enabled.  

---

## Local Overrides (private)

You can keep private or machine-specific settings in these optional files:

```
~/.zshrc.local
~/.vimrc.local
~/.config/nvim/local.lua
```

Add to `.gitignore`:
```
zsh/.zshrc.local
vim/.vimrc.local
nvim/.config/nvim/local.lua
```

---

## Maintenance

| Task | Vim | Neovim |
|---|---|---|
| Install/Sync plugins | `vim +PlugInstall +qall` | `:Lazy sync` |
| Clean unused plugins | `vim +PlugClean! +qall` | `:Lazy clean` |
| Update Treesitter | — | `:TSUpdate` |
| Health check | — | `:checkhealth` |

General:
```bash
# Pull latest dotfiles
git -C ~/.dotfiles pull

# Re-stow
cd ~/.dotfiles && stow -R zsh vim nvim ranger
```

---

## Troubleshooting

- **Neovim clipboard**  
  With `clipboard=unnamedplus`, `p` pastes from macOS clipboard.  
  To paste your last yank (not the clipboard): use `"0p`.

- **ctags path (Homebrew)**  
  If `gutentags` can’t find `ctags`, ensure:
  ```
  /opt/homebrew/bin/ctags
  ```
  is installed and on `PATH`.

---

## References

- [GNU Stow](https://www.gnu.org/software/stow/manual/stow.html)
- [Oh My Zsh](https://ohmyz.sh)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [vim-plug](https://github.com/junegunn/vim-plug)
- [VimTeX](https://github.com/lervag/vimtex)
- [fzf.vim](https://github.com/junegunn/fzf.vim)
- [NERDTree](https://github.com/preservim/nerdtree)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [ranger](https://github.com/ranger/ranger)
- [ranger_devicons](https://github.com/alexanderjeurissen/ranger_devicons)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
