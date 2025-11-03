return {
  "folke/tokyonight.nvim",
  lazy = false,          -- load on startup
  priority = 1000,       -- load before other plugins
  opts = {
    style = "storm",     -- choices: "storm", "night", "moon", "day"
    transparent = false, -- set to true if you want terminal background
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      sidebars = "dark",
      floats = "dark",
    },
    dim_inactive = true,
    lualine_bold = true,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd("colorscheme tokyonight")
  end,
}
