-- lua/plugins/telescope.lua
-- Telescope setup (finder config only; keymaps live in keymaps.lua)

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local ok, telescope = pcall(require, "telescope")
      if not ok then
        vim.notify("telescope.nvim failed to load", vim.log.levels.ERROR)
        return
      end

      telescope.setup({
        pickers = {
          find_files = {
            -- Use fd for speed; include hidden files but skip .git
            find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
            hidden = true,
            no_ignore = true,
            no_ignore_parent = true,
          },
        },
        defaults = {
          -- sensible defaults; tweak if you like
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
        },
      })

      -- Optional: make FZF_DEFAULT_COMMAND nicer if ripgrep exists
      if vim.fn.executable("rg") == 1 then
        vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/*"'
      end
    end,
  },
}
