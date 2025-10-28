-- lua/plugins/colors.lua
-- Colour schemes (set Gruvbox on startup)

return {
  -- Load Gruvbox early and apply it
  {
    "morhetz/gruvbox",
    lazy = false,
    priority = 1000,
    config = function()
      -- Apply Gruvbox; if it ever fails, try Gruvbox Material
      local ok = pcall(vim.cmd, "colorscheme gruvbox")
      if not ok then
        pcall(vim.cmd, "colorscheme gruvbox-material")
      end
    end,
  },

  -- Keep Gruvbox Material installed as an alternative
  { "sainnhe/gruvbox-material" },
}
