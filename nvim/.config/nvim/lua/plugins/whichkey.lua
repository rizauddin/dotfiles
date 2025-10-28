-- lua/plugins/whichkey.lua
-- Which-key plugin and icon support for Riza's Neovim setup

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      win = { border = "rounded" },
      plugins = { spelling = true },
      layout = {
        align = "center",
        spacing = 4,
      },
      icons = {
        separator = "➜",
        group = "+",
      },
      show_help = true,
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- Optional: custom group labels for common prefixes
      wk.register({
        ["<leader>f"] = { name = "+find" },
        ["<leader>b"] = { name = "+buffers" },
        ["<leader>g"] = { name = "+grep" },
        ["<leader>t"] = { name = "+toggle" },
        ["<leader>m"] = { name = "+markdown" },
        ["<leader>d"] = { name = "+diagnostics" },
        ["<leader>q"] = { name = "+quit/quickfix" },
      })
    end,
  },
}
