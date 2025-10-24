-- #############################################################################
-- ~/.config/nvim/init.lua
-- Author: Rizauddin Saian
-- Description:
--   Personal Neovim configuration optimised for development, writing, and
--   teaching. Uses lazy.nvim for plugin management, Gruvbox theme, and settings
--   tuned for readability, code editing, and LaTeX/Markdown work.
--
-- Repository:
--   https://github.com/rizauddin/dotfiles
--
-- Management:
--   This file is managed using GNU Stow.
--   To deploy (symlink) it to your home directory:
--     cd ~/.dotfiles && stow -v nvim
--
-- Notes:
--   - Safe for public sharing (no private paths or credentials)
--   - Plugin management via lazy.nvim (see :Lazy)
--   - If you use this config on a new machine:
--       :checkhealth
--       :Lazy sync
--   - Machine-specific settings (like font or custom scripts) should go in:
--       ~/.config/nvim/local.lua        (optional, git-ignored)
--   - LaTeX via vimtex uses Skim as the default PDF viewer (forward/inverse sync)
--     and latexmk with out/ as build dir.
--   - Clipboard: vim.opt.clipboard = "unnamedplus" makes y/p use macOS clipboard.
--     Use "0p to paste last yank if needed.
--   - Telescope replaces fzf.vim for files/buffers/grep.
--   - Extras provided: :PrettyJSON, :LatexClean, :LatexDoctor, :ReloadConfig.
-- #############################################################################

----------------------------------------------------
-- 0) Speed up Lua module loading (Neovim 0.9+)
----------------------------------------------------
pcall(function()
  if vim.loader and vim.loader.enable then vim.loader.enable() end
end)

----------------------------------------------------
-- 0.1) RPC server for Skim/nvr inverse search (fixed socket)
----------------------------------------------------
do
  local sockdir = vim.env.XDG_RUNTIME_DIR or "/tmp"
  local sock = sockdir .. "/nvim-riza"
  pcall(function() vim.fn.serverstart(sock) end)
  vim.g.nvim_listen_address = sock
end

----------------------------------------------------
-- 0.2) Leaders early
----------------------------------------------------
--vim.g.mapleader = vim.g.mapleader ~= "" and vim.g.mapleader or " "
vim.g.maplocalleader = vim.g.maplocalleader ~= "" and vim.g.maplocalleader or "\\"

----------------------------------------------------
-- 1) Bootstrap lazy.nvim
----------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git","clone","--filter=blob:none","--branch=stable",
    "https://github.com/folke/lazy.nvim", lazypath
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" },
      { "\nPlugins will not be managed by lazy.nvim.\n", "WarningMsg" },
    }, true, {})
  end
end
vim.opt.rtp:prepend(lazypath)

----------------------------------------------------
-- 2) Safe require helper
----------------------------------------------------
local function safe_require(mod)
  local ok, result = pcall(require, mod)
  if not ok then
    vim.schedule(function()
      vim.notify(("Error loading '%s': %s"):format(mod, result), vim.log.levels.ERROR)
    end)
  end
  return ok and result or nil
end

----------------------------------------------------
-- 3) Options roughly matching your .vimrc defaults
----------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.ruler = true
vim.opt.visualbell = true
vim.opt.laststatus = 2
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.mouse = "a"
vim.opt.wrap = false

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftround = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.foldmethod = "manual"
vim.opt.foldlevelstart = 99

vim.opt.updatetime = 300
vim.opt.completeopt = { "menuone", "noselect" }
--vim.opt.clipboard = "unnamedplus"
-- leader+y / leader+p for macOS clipboard
vim.keymap.set({"n","v"}, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>p", '"+p')

vim.opt.spell = true
vim.opt.spelllang = "en_gb"

-- Cursor shape like your .vimrc
vim.cmd([[let &t_SI = "\e[6 q"]])
vim.cmd([[let &t_EI = "\e[2 q"]])

-- Encourage hjkl like your .vimrc
vim.keymap.set("n", "<Up>",    function() vim.notify("Use k ya!") end, { silent = true })
vim.keymap.set("n", "<Down>",  function() vim.notify("Use j ya!") end, { silent = true })
vim.keymap.set("n", "<Left>",  function() vim.notify("Use h ya!") end, { silent = true })
vim.keymap.set("n", "<Right>", function() vim.notify("Use l ya!") end, { silent = true })

----------------------------------------------------
-- 4) Plugins (includes features from your .vimrc)
----------------------------------------------------
local plugin_spec = {

  -- Colours (from .vimrc)
  { "morhetz/gruvbox" },
  { "sainnhe/gruvbox-material" },

  -- which-key (nice to have) + icons
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { win = { border = "rounded" }, plugins = { spelling = true } },
  },

  -- Telescope (replaces fzf + provides finder/buffer/grep)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local tb = require("telescope.builtin")
      vim.keymap.set("n", "<leader>f", tb.find_files, { desc = "Files" })
      vim.keymap.set("n", "<leader>b", tb.buffers,    { desc = "Buffers" })
      vim.keymap.set("n", "<leader>g", tb.live_grep,  { desc = "Live Grep (ripgrep)" })
      vim.keymap.set("n", "<leader>w", tb.current_buffer_fuzzy_find, { desc = "Fuzzy in buffer" })
      if vim.fn.executable("rg") == 1 then
        vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/*"'
      end
    end,
  },

  -- Commenting (equivalent to vim-commentary)
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function() require("Comment").setup() end,
  },

  -- Copilot (from .vimrc)
  { "github/copilot.vim", event = "InsertEnter" },

  -- Emmet (from .vimrc)
  {
    "mattn/emmet-vim",
    event = "InsertEnter",
    init = function()
      -- minimal sane Emmet defaults; keep your big snippets in ~/.vimrc if you prefer
      vim.g.user_emmet_settings = {
        html = {
          default_attributes = { html = { lang = "en" }, meta = { charset = "UTF-8" } },
        },
      }
    end,
  },

  -- Markdown preview (from .vimrc)
{
  "iamcco/markdown-preview.nvim",
  ft = { "markdown" },
  build = "cd app && npm install", -- or yarn install if you prefer
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_auto_start = 0
  end,
},

  -- Formatter: Conform (use Prettier etc.)
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      format_on_save = function(buf)
        local disable = vim.g.disable_autoformat or vim.b[buf].disable_autoformat
        if disable then return end
        return { timeout_ms = 2000, lsp_fallback = true }
      end,
      formatters_by_ft = {
        javascript = { "prettier" }, typescript = { "prettier" },
        javascriptreact = { "prettier" }, typescriptreact = { "prettier" },
        css = { "prettier" }, html = { "prettier" }, json = { "prettier" },
        markdown = { "prettier" },
      },
    },
  },

  -- Treesitter for JS/TS/JSX/GraphQL syntax (replaces several old vim syntax plugins)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      highlight = { enable = true },
      ensure_installed = {
        "lua","vim","vimdoc","bash","json","html","css","javascript","typescript","tsx","graphql","markdown","markdown_inline", "java", "python"
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Gutentags (from .vimrc)
  {
    "ludovicchabant/vim-gutentags",
    init = function()
      vim.g.gutentags_ctags_executable = "/opt/homebrew/bin/ctags"
      vim.g.gutentags_cache_dir = vim.fn.expand("~/.cache/gutentags")
      vim.g.gutentags_project_root = { ".git", ".hg", ".svn" }
      vim.g.gutentags_modules = { "ctags" }
      vim.opt.tags = "./tags;/"  -- like your .vimrc
    end,
  },

  -- LaTeX: vimtex with Skim viewer (keep \ll)
  {
    "lervag/vimtex",
    lazy = false,
    ft = { "tex" },
    init = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 1
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "out",
        options = { "-pdf","-file-line-error","-synctex=1","-interaction=nonstopmode" },
      }
      vim.g.tex_flavor = "latex"
    end,
  },
}

----------------------------------------------------
-- 5) Setup lazy.nvim
----------------------------------------------------
local lazy = safe_require("lazy")
if lazy then
  lazy.setup(plugin_spec, {
    ui = { border = "rounded" },
    checker = { enabled = true, notify = false, frequency = 24 * 60 * 60 },
    performance = { rtp = { disabled_plugins = { "gzip","tarPlugin","tohtml","tutor","zipPlugin" } } },
  })
end

----------------------------------------------------
-- 6) Commands & autocmds mirroring your .vimrc
----------------------------------------------------
-- Colourscheme (from .vimrc)
pcall(vim.cmd, "colorscheme gruvbox")

-- PrettyJSON command (from .vimrc)
vim.api.nvim_create_user_command("PrettyJSON", function()
  vim.cmd("%!python3 -m json.tool")
end, { desc = "Format buffer as pretty JSON" })

-- Markdown wrap/linebreak (from .vimrc)
vim.api.nvim_create_augroup("markdown_settings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "markdown_settings",
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

-- Source legacy helper if it exists (from .vimrc)
vim.api.nvim_create_augroup("wrapwithtag", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "wrapwithtag",
  pattern = { "html", "xml" },
  callback = function()
    local p = vim.fn.expand("~/.vim/scripts/wrapwithtag.vim")
    if vim.fn.filereadable(p) == 1 then vim.cmd("source " .. p) end
  end,
})

----------------------------------------------------
-- 7) Helpers: :ReloadConfig, :LatexClean, :LatexDoctor
----------------------------------------------------
vim.api.nvim_create_user_command("ReloadConfig", function()
  for name,_ in pairs(package.loaded) do
    if name:match("^config%.") then package.loaded[name] = nil end
  end
  dofile(vim.env.MYVIMRC)
  vim.notify("Config reloaded", vim.log.levels.INFO)
end, { desc = "Reload init.lua and local modules" })

local function latex_clean()
  local root = (vim.fn.exists("*vimtex#util#root") == 1) and vim.fn["vimtex#util#root"]() or vim.fn.getcwd()
  local patterns = {
    "*.aux","*.bbl","*.bcf","*.blg","*.fdb_latexmk","*.fls","*.log","*.out",
    "*.run.xml","*.synctex.gz","*.toc","*.nav","*.snm","*.vrb","*.xdv",
    "*.acn","*.acr","*.alg","*.glg","*.glo","*.gls","*.ist","*.lot","*.lof",
  }
  local deleted = {}
  for _, pat in ipairs(patterns) do
    for _, f in ipairs(vim.fn.globpath(root, pat, false, true)) do
      if vim.fn.filereadable(f) == 1 then vim.fn.delete(f); table.insert(deleted, f) end
    end
  end
  local build_dir = root .. "/out"
  if vim.fn.isdirectory(build_dir) == 1 then vim.fn.delete(build_dir, "rf"); table.insert(deleted, build_dir .. "/") end
  if #deleted == 0 then
    vim.notify("LatexClean: nothing to remove", vim.log.levels.INFO)
  else
    vim.notify("LatexClean removed:\n  " .. table.concat(deleted, "\n  "), vim.log.levels.INFO)
  end
end
vim.api.nvim_create_user_command("LatexClean", latex_clean, { desc = "Remove LaTeX aux files and out/ directory" })

local function check_exec(name) return vim.fn.executable(name) == 1 end
vim.api.nvim_create_user_command("LatexDoctor", function()
  local uname = vim.loop.os_uname().sysname or ""
  local rpt = {}
  local function ok(cond, good, bad) table.insert(rpt, (cond and "[OK]  " .. good) or "[FAIL] " .. bad) end
  ok(uname == "Darwin", "macOS detected", "Skim workflow targets macOS")
  ok(vim.fn.isdirectory("/Applications/Skim.app") == 1, "Skim app in /Applications", "Skim not found")
  ok(check_exec("latexmk"), "latexmk in PATH", "latexmk missing")
  ok(check_exec("nvr"), "nvr in PATH", "nvr missing (pipx install neovim-remote)")
  ok(vim.g.vimtex_view_method == "skim", "vimtex_view_method=skim", "vimtex_view_method not skim")
  table.insert(rpt, ("Neovim server: %s"):format(vim.g.nvim_listen_address or "(none)"))
  table.insert(rpt, "Skim ▸ Preferences ▸ Sync: Command=/opt/homebrew/bin/nvr  Args=--server "
    .. (vim.g.nvim_listen_address or "/tmp/nvim-riza") .. ' --remote-silent +"%line" "%file"')
  vim.notify(table.concat(rpt, "\n"), vim.log.levels.INFO, { title = "LatexDoctor" })
end, { desc = "Check Skim + nvr + latexmk + vimtex setup" })

----------------------------------------------------
-- 8) UI niceties
----------------------------------------------------
vim.keymap.set("n", "<leader>lz", "<cmd>Lazy<cr>", { desc = "Open lazy.nvim UI" })
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local v = vim.version()
    vim.defer_fn(function()
      vim.notify(("Neovim %d.%d.%d ready."):format(v.major, v.minor, v.patch), vim.log.levels.INFO, { title = "Startup" })
    end, 50)
  end,
})
