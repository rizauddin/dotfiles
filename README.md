# Dotfiles by Rizauddin Saian

This repository contains my personal configuration files (dotfiles) for **Zsh** and **Vim**, designed for macOS + Homebrew environment.  
All files are managed using **[GNU Stow](https://www.gnu.org/software/stow/)** to make them portable, modular, and easy to maintain.

---

## Repository Structure

```
~/.dotfiles
├── zsh/
│   └── .zshrc          # Shell configuration (Oh My Zsh + Powerlevel10k)
├── vim/
│   └── .vimrc          # Main Vim configuration
└── README.md
```

Each folder mirrors your `$HOME` directory layout.  
GNU Stow creates symbolic links from these folders to the actual configuration files in your home directory.

---

## Using GNU Stow

### 1. Install Stow
If you’re on macOS:
```bash
brew install stow
```

### 2. Clone this repo
```bash
git clone git@github.com:rizauddin/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 3. Deploy (symlink) configuration files
```bash
stow -v zsh vim
```

This will create:
```
~/.zshrc  → ~/.dotfiles/zsh/.zshrc
~/.vimrc  → ~/.dotfiles/vim/.vimrc
```
Vim plugins and runtime files (installed by `vim-plug`) remain in `~/.vim/`, which is not part of version control.

### 4. To remove symlinks
```bash
stow -D zsh vim
```

### 5. To reapply symlinks
```bash
stow -R zsh vim
```

---

## Zsh Configuration

The `.zshrc` file provides a ready-to-use, feature-rich shell setup.

### Features
- **Oh My Zsh** with `robbyrussell` theme
- **Powerlevel10k** prompt theme
- **zsh-syntax-highlighting** and **zsh-autosuggestions**
- **zoxide** for smart directory navigation
- Configured **PATHs** for:
  - Homebrew
  - Java (OpenJDK)
  - Flutter / Dart
  - Android SDK / AVD / Build-tools
  - Python (Anaconda)
  - R Framework
- Support for **NVM**, **SDKMAN**, and **Weka/Myra**
- Useful **aliases**:
  - `ls`, `ll` – coloured file listing
  - `chrome` – open a new Chrome profile window
  - `sinarfm`, `ikimfm`, etc. – listen to radio streams via `mpv`

### Setup Steps
1. Install Oh My Zsh  
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```
2. Install Powerlevel10k  
   ```bash
   brew install romkatv/powerlevel10k/powerlevel10k
   ```
3. Run the configuration wizard:  
   ```bash
   p10k configure
   ```
4. Reload Zsh to apply settings:  
   ```bash
   source ~/.zshrc
   ```

---

## Vim Configuration

The `.vimrc` is optimised for **LaTeX**, **HTML**, **JavaScript**, **TypeScript**, and **Markdown** editing, with intelligent indentation, syntax highlighting, and plugin integration.

### Plugins (via [vim-plug](https://github.com/junegunn/vim-plug))
- **lervag/vimtex** – LaTeX support
- **junegunn/fzf** & **fzf.vim** – file search
- **preservim/nerdtree** – file explorer
- **neoclide/coc.nvim** – autocompletion & LSP
- **mattn/emmet-vim** – HTML expansion
- **tpope/vim-commentary** – commenting
- **prettier/vim-prettier** – code formatting
- **iamcco/markdown-preview.nvim** – Markdown live preview
- **morhetz/gruvbox** – colour scheme
- **vim-gutentags** – automatic tag management

### Key Features
- Dark **Gruvbox** theme
- Relative line numbers
- Automatic indentation & syntax highlighting
- Mouse support
- Smart search (`ignorecase`, `incsearch`)
- HTML/JSX/TSX syntax support
- JSON and Markdown prettifiers
- Folding (`zf` to fold, `zR` to unfold all)
- Easy tag management (`ctags` integration)

### Special Commands

| Command | Mode | Description |
|----------|------|-------------|
| `\ll` | Normal | Compile LaTeX file via **VimTeX** |
| `\lv` | Normal | View compiled PDF (opens in **Skim**) |
| `\li` | Normal | Show LaTeX compiler info |
| `:Files` or `<leader>f` | Normal | Open **fzf** file search |
| `<leader>n` | Normal | Toggle **NERDTree** file explorer |
| `<leader>w` | Normal | Wrap selection with HTML tag (requires `wrapwithtag.vim`) |
| `:PrettyJSON` | Command | Format JSON using Python |
| `<C-Space>` | Insert | Trigger CoC autocompletion |
| `<Tab>` / `<S-Tab>` | Insert | Navigate suggestion menu |

### Emmet Snippets
Your Emmet setup includes:
- `html:5` — Standard HTML5 boilerplate
- `html:pro` — Professional SEO-ready template
- `html:bs` — Bootstrap 5 responsive template

To expand, type the abbreviation and press:  
`Ctrl + y ,` in **Insert mode**

### LaTeX Workflow (VimTeX)
- Compiler: `latexmk`
- PDF Viewer: **Skim**  
  (`let g:Tex_ViewRule_pdf = 'open -a Skim'`)
- Forward search (`\lv`) supported via SyncTeX

### 🪄 Plugin Installation
To install all plugins after cloning:
```bash
vim +PlugInstall +qall
```

---

## Local Overrides

You can keep private or machine-specific settings in these optional files:
```
~/.zshrc.local
~/.vimrc.local
```

Both are **ignored by Git** and sourced automatically if they exist.

Add this to `.gitignore`:
```
zsh/.zshrc.local
vim/.vimrc.local
```

---

## Maintenance

| Task | Command |
|------|----------|
| Update dotfiles | `git pull` |
| Add new config | `stow -v <folder>` |
| Remove config | `stow -D <folder>` |
| Check syntax | `zsh -n ~/.zshrc` |
| Reinstall Vim plugins | `vim +PlugClean! +PlugInstall +qall` |

---

## References

- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Oh My Zsh](https://ohmyz.sh)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Vim Plug](https://github.com/junegunn/vim-plug)
- [VimTeX](https://github.com/lervag/vimtex)
- [fzf.vim](https://github.com/junegunn/fzf.vim)
- [NERDTree](https://github.com/preservim/nerdtree)
