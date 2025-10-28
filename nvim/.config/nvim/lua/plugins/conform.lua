-- lua/plugins/conform.lua
-- Conform.nvim: lightweight formatter for multiple filetypes

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      format_on_save = function(buf)
        local disable = vim.g.disable_autoformat or vim.b[buf].disable_autoformat
        if disable then
          return
        end
        return { timeout_ms = 2000, lsp_fallback = true }
      end,
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
      },
    },
    config = function(_, opts)
      local ok, conform = pcall(require, "conform")
      if not ok then
        vim.notify("Conform.nvim failed to load", vim.log.levels.ERROR)
        return
      end
      conform.setup(opts)
    end,
  },
}
