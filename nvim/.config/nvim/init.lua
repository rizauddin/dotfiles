-- #############################################################################
-- ~/.config/nvim/init.lua
-- Author: Rizauddin Saian
-- Description:
--   Modular Neovim configuration optimised for development, writing, and teaching.
--   Uses lazy.nvim for plugin management, Gruvbox theme, and settings tuned for
--   readability, LaTeX, and Markdown work.
--
-- Repository:
--   https://github.com/rizauddin/dotfiles
--
-- Management:
--   Managed using GNU Stow.
--   To deploy (symlink) it to your home directory:
--     cd ~/.dotfiles && stow -v nvim
--
-- Notes:
--   - Plugins managed via lazy.nvim (see :Lazy)
--   - Run :checkhealth and :Lazy sync on a new machine
--   - Machine-specific tweaks go in ~/.config/nvim/local.lua (git-ignored)
--   - VimTeX uses Skim as viewer; y/p integrate with macOS clipboard
--   - Telescope replaces fzf; extras: :PrettyJSON, :LatexClean, :LatexDoctor
-- #############################################################################

----------------------------------------------------
-- 0) Speed up Lua module loading
----------------------------------------------------
pcall(function()
  if vim.loader and vim.loader.enable then vim.loader.enable() end
end)

----------------------------------------------------
-- 0.1) RPC server for Skim/nvr inverse search
----------------------------------------------------
do
  local sockdir = vim.env.XDG_RUNTIME_DIR or "/tmp"
  local sock = sockdir .. "/nvim-riza"
  pcall(function() vim.fn.serverstart(sock) end)
  vim.g.nvim_listen_address = sock
end

----------------------------------------------------
-- 0.2) Leaders (set early)
----------------------------------------------------
--vim.g.mapleader = vim.g.mapleader ~= "" and vim.g.mapleader or " "
--vim.g.maplocalleader = vim.g.maplocalleader ~= "" and vim.g.maplocalleader or "\\"

----------------------------------------------------
-- 1) Core settings, keymaps, plugins, and autocmds
----------------------------------------------------
require("options")
require("keymaps")
require("plugins")
require("autocmds")

----------------------------------------------------
-- 2) Colorscheme
----------------------------------------------------
pcall(vim.cmd, "colorscheme gruvbox")

----------------------------------------------------
-- 3) Custom commands
----------------------------------------------------

-- PrettyJSON
vim.api.nvim_create_user_command("PrettyJSON", function()
  vim.cmd("%!python3 -m json.tool")
end, { desc = "Format buffer as pretty JSON" })

-- Reload configuration
vim.api.nvim_create_user_command("ReloadConfig", function()
  for name,_ in pairs(package.loaded) do
    if name:match("^config%.") then package.loaded[name] = nil end
  end
  dofile(vim.env.MYVIMRC)
  vim.notify("Configuration reloaded", vim.log.levels.INFO)
end, { desc = "Reload init.lua and modules" })

-- LatexClean
local function latex_clean()
  local root = (vim.fn.exists("*vimtex#util#root") == 1)
    and vim.fn["vimtex#util#root"]() or vim.fn.getcwd()
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
  if vim.fn.isdirectory(build_dir) == 1 then
    vim.fn.delete(build_dir, "rf"); table.insert(deleted, build_dir .. "/")
  end
  if #deleted == 0 then
    vim.notify("LatexClean: nothing to remove", vim.log.levels.INFO)
  else
    vim.notify("LatexClean removed:\n  " .. table.concat(deleted, "\n  "), vim.log.levels.INFO)
  end
end
vim.api.nvim_create_user_command("LatexClean", latex_clean, { desc = "Remove LaTeX aux files and out/ dir" })

-- LatexDoctor
local function check_exec(name) return vim.fn.executable(name) == 1 end
vim.api.nvim_create_user_command("LatexDoctor", function()
  local uname = vim.loop.os_uname().sysname or ""
  local rpt = {}
  local function ok(cond, good, bad)
    table.insert(rpt, (cond and "[OK]  " .. good) or "[FAIL] " .. bad)
  end
  ok(uname == "Darwin", "macOS detected", "Skim workflow targets macOS")
  ok(vim.fn.isdirectory("/Applications/Skim.app") == 1, "Skim app in /Applications", "Skim not found")
  ok(check_exec("latexmk"), "latexmk in PATH", "latexmk missing")
  ok(check_exec("nvr"), "nvr in PATH", "nvr missing (pipx install neovim-remote)")
  ok(vim.g.vimtex_view_method == "skim", "vimtex_view_method=skim", "vimtex_view_method not skim")
  table.insert(rpt, ("Neovim server: %s"):format(vim.g.nvim_listen_address or "(none)"))
  table.insert(rpt,
    "Skim ▸ Preferences ▸ Sync:\nCommand=/opt/homebrew/bin/nvr  Args=--server "
    .. (vim.g.nvim_listen_address or "/tmp/nvim-riza")
    .. ' --remote-silent +"%line" "%file"')
  vim.notify(table.concat(rpt, "\n"), vim.log.levels.INFO, { title = "LatexDoctor" })
end, { desc = "Check Skim + nvr + latexmk + vimtex setup" })

----------------------------------------------------
-- 4) UI niceties
----------------------------------------------------
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local v = vim.version()
    vim.defer_fn(function()
      vim.notify(("Neovim %d.%d.%d ready."):format(v.major, v.minor, v.patch),
        vim.log.levels.INFO, { title = "Startup" })
    end, 50)
  end,
})

----------------------------------------------------
-- 5) Local config (optional, git-ignored)
----------------------------------------------------
local local_conf = vim.fn.stdpath("config") .. "/local.lua"
if vim.fn.filereadable(local_conf) == 1 then
  dofile(local_conf)
end
