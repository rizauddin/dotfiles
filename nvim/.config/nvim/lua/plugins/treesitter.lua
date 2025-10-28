-- lua/plugins/treesitter.lua
-- Treesitter for better syntax highlighting and parsing

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      highlight = { enable = true },
      ensure_installed = {
        "lua","vim","vimdoc","bash","json","html","css",
        "javascript","typescript","tsx","graphql",
        "markdown","markdown_inline","java","python",
      },
      -- auto_install = true, -- uncomment if you want missing parsers to auto-install
    },
    config = function(_, opts)
      local ok, ts = pcall(require, "nvim-treesitter.configs")
      if not ok then
        vim.notify("nvim-treesitter failed to load", vim.log.levels.ERROR)
        return
      end
      ts.setup(opts)
    end,
  },
}
