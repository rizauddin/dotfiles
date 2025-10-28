-- ~/.config/nvim/lua/config/lazy.lua
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

require("lazy").setup({
  spec = { { import = "plugins" } }, -- load all from lua/plugins
  ui = { border = "rounded" },
  checker = { enabled = true, notify = false, frequency = 24 * 60 * 60 },
  performance = {
    rtp = { disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" } },
  },
})
