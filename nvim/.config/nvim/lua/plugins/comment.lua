-- lua/plugins/comment.lua
-- Comment.nvim configuration for Riza's Neovim setup

return {
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local ok, comment = pcall(require, "Comment")
      if not ok then
        vim.notify("Comment.nvim failed to load", vim.log.levels.ERROR)
        return
      end

      comment.setup({
        padding = true,
        sticky = true,
        ignore = "^$", -- ignore empty lines
        toggler = {
          line = "gcc",
          block = "gbc",
        },
        opleader = {
          line = "gc",
          block = "gb",
        },
        mappings = {
          basic = true,
          extra = false, -- keep keymaps simple
        },
      })
    end,
  },
}
