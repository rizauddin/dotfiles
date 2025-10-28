-- lua/plugins/colorizer.lua
return {
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      filetypes = { "css", "scss", "sass", "less", "html", "javascript", "typescript", "tsx", "jsx", "lua", "vim", "markdown" },
      user_default_options = {
        names = false,
        tailwind = true,
        mode = "background",
        RRGGBB = true,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        AARRGGBB = true,
        css = true,
        css_fn = true,
        always_update = true,
      },
    },
  },
}
