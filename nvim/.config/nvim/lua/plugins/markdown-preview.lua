-- lua/plugins/markdown-preview.lua
-- Markdown preview plugin configuration

return {
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = "cd app && npm install",  -- ensures dependencies are installed
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_start = 0        -- don't start automatically
      vim.g.mkdp_auto_close = 1        -- close preview when buffer is closed
      vim.g.mkdp_browser = ""          -- use system default browser
      vim.g.mkdp_theme = "dark"        -- matches your general Gruvbox setup
    end,
  },
}
