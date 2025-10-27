-- lua/options.lua
-- Core editor options for Riza's Neovim setup

local o, wo, bo, g = vim.opt, vim.wo, vim.bo, vim.g

----------------------------------------------------
-- UI
----------------------------------------------------
o.number          = true
o.relativenumber  = true
o.cursorline      = true
o.signcolumn      = "yes"
o.ruler           = true
o.showmatch       = true
o.laststatus      = 2
o.termguicolors   = true
o.background      = "dark"
o.mouse           = "a"
o.wrap            = false              -- default off; toggle with <leader>tw in keymaps

-- Spelling
o.spell           = true
o.spelllang       = "en_gb"

-- Cursor shape (terminal): 6 q = bar in insert, 2 q = block in normal
vim.cmd([[let &t_SI = "\e[6 q"]])
vim.cmd([[let &t_EI = "\e[2 q"]])

----------------------------------------------------
-- Search
----------------------------------------------------
o.ignorecase      = true
o.smartcase       = true
o.incsearch       = true
o.hlsearch        = false

----------------------------------------------------
-- Indentation & tabs
----------------------------------------------------
o.expandtab       = true
o.shiftwidth      = 2
o.tabstop         = 2
o.softtabstop     = 2
o.shiftround      = true
o.autoindent      = true
o.smartindent     = true

----------------------------------------------------
-- Folds
----------------------------------------------------
o.foldmethod      = "manual"
o.foldlevelstart  = 99

----------------------------------------------------
-- Completion & performance
----------------------------------------------------
o.completeopt     = { "menuone", "noselect" }
o.updatetime      = 300

----------------------------------------------------
-- Tags (works nicely with Gutentags too)
----------------------------------------------------
o.tags            = "./tags;/"

----------------------------------------------------
-- Clipboard (macOS): use system clipboard unless over SSH
----------------------------------------------------
local is_macos = (vim.loop.os_uname().sysname or "") == "Darwin"
if is_macos and not vim.env.SSH_TTY and vim.fn.executable("pbcopy") == 1 then
  -- Uncomment if you want default y/p to use macOS clipboard.
  -- You already have <leader>y / <leader>p in keymaps as explicit ops.
  -- o.clipboard = "unnamedplus"
end

----------------------------------------------------
-- Transparency (iTerm2 + any colourscheme)
----------------------------------------------------
-- Reapply on every colourscheme load
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.cmd([[
      hi Normal guibg=none ctermbg=none
      hi NormalNC guibg=none ctermbg=none
      hi SignColumn guibg=none
      hi LineNr guibg=none
      hi EndOfBuffer guibg=none
      hi NeoTreeNormal guibg=none
      hi NeoTreeNormalNC guibg=none
      hi TelescopeNormal guibg=none
      hi TelescopeBorder guibg=none
      hi StatusLine guibg=none
      hi StatusLineNC guibg=none
      hi TabLine guibg=none
      hi TabLineFill guibg=none
    ]])
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
  end,
})

-- Apply once on startup (before any later colourscheme override)
pcall(function()
  vim.cmd([[
    hi Normal guibg=none ctermbg=none
    hi NormalNC guibg=none ctermbg=none
    hi SignColumn guibg=none
    hi LineNr guibg=none
    hi EndOfBuffer guibg=none
    hi NeoTreeNormal guibg=none
    hi NeoTreeNormalNC guibg=none
    hi TelescopeNormal guibg=none
    hi TelescopeBorder guibg=none
    hi StatusLine guibg=none
    hi StatusLineNC guibg=none
    hi TabLine guibg=none
    hi TabLineFill guibg=none
  ]])
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
end)

return true


