-- lua/plugins/emmet.lua
-- Emmet plugin for fast HTML/CSS snippet expansion

return {
  {
    "mattn/emmet-vim",
    event = "InsertEnter",
    init = function()
      -- Basic default settings
      vim.g.user_emmet_settings = {
        html = {
          default_attributes = {
            html = { lang = "en" },
            meta = { charset = "UTF-8" },
          },
        },
      }

      -- Optional: expand abbreviation with <C-y>,
      -- works well in insert mode (Emmet default)
      vim.g.user_emmet_leader_key = "<C-y>"
    end,
  },
}
