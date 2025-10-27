-- lua/plugins.lua
-- Plugin specifications and setup for lazy.nvim

----------------------------------------------------
-- Helper: safe require
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
-- Bootstrap lazy.nvim
----------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
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
-- Plugin list
----------------------------------------------------
local plugin_spec = {
  -- Colourschemes
  { "morhetz/gruvbox" },
  { "sainnhe/gruvbox-material" },

  -- which-key and icons
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { win = { border = "rounded" }, plugins = { spelling = true } },
  },

  -- Telescope finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local tb = require("telescope.builtin")
      vim.keymap.set("n", "<leader>f", tb.find_files, { desc = "Files" })
      vim.keymap.set("n", "<leader>b", tb.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>g", tb.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>w", tb.current_buffer_fuzzy_find, { desc = "Search buffer" })
      vim.keymap.set("n", "<leader>fh", tb.help_tags, { desc = "Help tags" })
      if vim.fn.executable("rg") == 1 then
        vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/*"'
      end
    end,
  },

  -- Comment toggling
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function() require("Comment").setup() end,
  },

  -- GitHub Copilot
  { "github/copilot.vim", event = "InsertEnter" },

  -- Emmet
  {
    "mattn/emmet-vim",
    event = "InsertEnter",
    init = function()
      vim.g.user_emmet_settings = {
        html = { default_attributes = { html = { lang = "en" }, meta = { charset = "UTF-8" } } },
      }
    end,
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_start = 0
    end,
  },

  -- Formatter (Conform)
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
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
      },
    },
  },

  -- Treesitter syntax
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      highlight = { enable = true },
      ensure_installed = {
        "lua","vim","vimdoc","bash","json","html","css",
        "javascript","typescript","tsx","graphql",
        "markdown","markdown_inline","java","python"
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Gutentags
  {
    "ludovicchabant/vim-gutentags",
    init = function()
      vim.g.gutentags_ctags_executable = "/opt/homebrew/bin/ctags"
      vim.g.gutentags_cache_dir = vim.fn.expand("~/.cache/gutentags")
      vim.g.gutentags_project_root = { ".git", ".hg", ".svn" }
      vim.g.gutentags_modules = { "ctags" }
      vim.opt.tags = "./tags;/"
    end,
  },

  -- LaTeX (vimtex)
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
        options = { "-pdf", "-file-line-error", "-synctex=1", "-interaction=nonstopmode" },
      }
      vim.g.tex_flavor = "latex"
    end,
  },
}

----------------------------------------------------
-- Setup lazy.nvim
----------------------------------------------------
local lazy = safe_require("lazy")
if lazy then
  lazy.setup(plugin_spec, {
    ui = { border = "rounded" },
    checker = { enabled = true, notify = false, frequency = 24 * 60 * 60 },
    performance = {
      rtp = { disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" } },
    },
  })
end
