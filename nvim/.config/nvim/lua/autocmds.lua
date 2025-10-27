-- lua/autocmds.lua
-- Autocommands split out from init.lua to keep things tidy.

----------------------------------------------------
-- Helpers
----------------------------------------------------
local function augroup(name)
  return vim.api.nvim_create_augroup("riza_" .. name, { clear = true })
end

----------------------------------------------------
-- Markdown: wrap and linebreak
----------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("markdown"),
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    -- keep spell from options.lua; ensure it stays on in md
    vim.opt_local.spell = true
  end,
})

----------------------------------------------------
-- HTML/XML helper: source legacy wrapwithtag.vim if present
----------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("html_xml_helper"),
  pattern = { "html", "xml" },
  callback = function()
    local p = vim.fn.expand("~/.vim/scripts/wrapwithtag.vim")
    if vim.fn.filereadable(p) == 1 then
      vim.cmd("source " .. p)
    end
  end,
})

----------------------------------------------------
-- Highlight on yank
----------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("yank_highlight"),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 120 })
  end,
})

----------------------------------------------------
-- Equalise splits on resize
----------------------------------------------------
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("wincmd =")
  end,
})

----------------------------------------------------
-- Return to last cursor position when reopening a file
----------------------------------------------------
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_location"),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

----------------------------------------------------
-- Auto check for external file changes on focus or buffer enter
----------------------------------------------------
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = augroup("autoread"),
  callback = function()
    if vim.fn.mode() == "n" then
      vim.cmd("checktime")
    end
  end,
})

----------------------------------------------------
-- Trim trailing whitespace on save (skip Markdown and TeX)
----------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("trim_whitespace"),
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if ft == "markdown" or ft == "tex" then return end
    -- keep view, do the substitution silently, then restore view
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

----------------------------------------------------
-- Quick close for temporary/list-like buffers
----------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("quick_close"),
  pattern = {
    "help", "qf", "lspinfo", "checkhealth", "startuptime", "tsplayground",
    "git", "gitcommit", "fugitive", "spectre_panel",
  },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true, silent = true })
    -- make help wrap nicely
    if vim.bo.filetype == "help" then
      vim.opt_local.wrap = true
      vim.opt_local.linebreak = true
    end
  end,
})

----------------------------------------------------
-- LaTeX: ensure compiler/build dir settings are honoured per buffer
-- (vimtex handles most things; this is a light guard)
----------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("latex"),
  pattern = "tex",
  callback = function()
    -- Keep conceal minimal for readability while editing
    vim.opt_local.conceallevel = 0
    -- Spellcheck in TeX
    vim.opt_local.spell = true
  end,
})
