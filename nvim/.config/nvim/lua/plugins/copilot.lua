-- lua/plugins/copilot.lua
-- GitHub Copilot configuration for Riza's Neovim setup

return {
  {
    "github/copilot.vim",
    lazy = false,  -- load at startup (ensures reliability)
    init = function()
      -- Disable <Tab> mapping to avoid conflicts with other plugins
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true

      -- Optional: control which filetypes Copilot is active in
      -- vim.g.copilot_filetypes = { markdown = true, ["*"] = true }

      -- Use Ctrl-J for accepting suggestions (cleaner than <Tab>)
      vim.keymap.set(
        "i",
        "<C-j>",
        'copilot#Accept("<CR>")',
        { expr = true, replace_keycodes = false, silent = true, desc = "Accept Copilot suggestion" }
      )
    end,
  },
}
