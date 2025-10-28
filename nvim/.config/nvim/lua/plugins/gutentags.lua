-- lua/plugins/gutentags.lua
-- Gutentags: automatic ctags management for faster navigation

return {
  {
    "ludovicchabant/vim-gutentags",
    init = function()
      -- Use Homebrew’s ctags path on macOS
      vim.g.gutentags_ctags_executable = "/opt/homebrew/bin/ctags"

      -- Cache directory for generated tag files
      vim.g.gutentags_cache_dir = vim.fn.expand("~/.cache/gutentags")

      -- Recognise project roots
      vim.g.gutentags_project_root = { ".git", ".hg", ".svn" }

      -- Only use ctags module (no gtags or others)
      vim.g.gutentags_modules = { "ctags" }

      -- Make Vim aware of the tag search path
      vim.opt.tags = "./tags;/"
    end,
  },
}
