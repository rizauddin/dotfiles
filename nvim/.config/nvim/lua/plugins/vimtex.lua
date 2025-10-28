-- lua/plugins/vimtex.lua
-- VimTeX configuration for LaTeX editing and compilation

return {
  {
    "lervag/vimtex",
    lazy = false,
    ft = { "tex" },
    init = function()
      -- Viewer setup (macOS: Skim)
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 1

      -- Compiler settings
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "out",
        options = { "-pdf", "-file-line-error", "-synctex=1", "-interaction=nonstopmode" },
      }

      -- Language and flavour
      vim.g.tex_flavor = "latex"

      -- Optional: auto conceal can be toggled here
      vim.g.vimtex_syntax_conceal = { accents = 0, ligatures = 0, cites = 0, refs = 0 }

      -- Disable VimTeX intro message
      vim.g.vimtex_quickfix_open_on_warning = 0
    end,
  },
}
