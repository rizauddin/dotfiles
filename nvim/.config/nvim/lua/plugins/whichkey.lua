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
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- New v3-style spec (array of tables). Register only prefixes that are NOT real mappings.
      wk.add({
        { "<leader>d", group = "diagnostics" },  -- you use <leader>dq etc., no plain <leader>d mapping:contentReference[oaicite:1]{index=1}
        { "<leader>m", group = "markdown" },     -- you use <leader>mp / <leader>ms in Markdown:contentReference[oaicite:2]{index=2}
        { "<leader>t", group = "toggle" },       -- you use <leader>tn / <leader>ts / <leader>tw:contentReference[oaicite:3]{index=3}
        -- DO NOT register <leader>q: you mapped it to :quit already:contentReference[oaicite:4]{index=4}
        -- DO NOT register <leader>f / b / g / w: you mapped them to Telescope pickers:contentReference[oaicite:5]{index=5}
      })
    end,
  },
}

