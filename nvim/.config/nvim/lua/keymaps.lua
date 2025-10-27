-- lua/keymaps.lua
-- Centralised keymaps for Riza's Neovim config
-- Safe to source multiple times.

----------------------------------------------------
-- Helper
----------------------------------------------------
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, desc = desc })
end

-- Optional safe require
local function try_require(name)
  local ok, mod = pcall(require, name)
  return ok and mod or nil
end

----------------------------------------------------
-- Basic editing & navigation
----------------------------------------------------
-- Save / quit
map("n", "<leader>w", "<cmd>write<cr>", "Write")
map("n", "<leader>q", "<cmd>quit<cr>", "Quit")
map("n", "<leader>x", "<cmd>x<cr>", "Write & quit")

-- System clipboard helpers (macOS-friendly)
map({ "n", "v" }, "<leader>y", '"+y', "Yank to system clipboard")
map("n", "<leader>p", '"+p',       "Paste from system clipboard")

-- Window movement like tmux
map("n", "<C-h>", "<C-w>h", "Go to left window")
map("n", "<C-j>", "<C-w>j", "Go to lower window")
map("n", "<C-k>", "<C-w>k", "Go to upper window")
map("n", "<C-l>", "<C-w>l", "Go to right window")

-- Window management
map("n", "<leader>sv", "<cmd>vsplit<cr>", "Vertical split")
map("n", "<leader>sh", "<cmd>split<cr>",  "Horizontal split")
map("n", "<leader>se", "<C-w>=",          "Equalise window sizes")
map("n", "<leader>sx", "<cmd>close<cr>",  "Close window")

-- Buffer navigation
map("n", "]b", "<cmd>bnext<cr>",     "Next buffer")
map("n", "[b", "<cmd>bprevious<cr>", "Prev buffer")
map("n", "<leader>bd", "<cmd>bdelete<cr>", "Delete buffer")

-- Quickfix / location lists
map("n", "]q", "<cmd>cnext<cr>",     "Next quickfix")
map("n", "[q", "<cmd>cprevious<cr>", "Prev quickfix")
map("n", "<leader>qo", "<cmd>copen<cr>",   "Open quickfix")
map("n", "<leader>qc", "<cmd>cclose<cr>",  "Close quickfix")

-- Toggles
map("n", "<leader>tn", function()
  vim.wo.number = not vim.wo.number
  vim.wo.relativenumber = vim.wo.number and vim.wo.relativenumber
end, "Toggle line numbers")

map("n", "<leader>ts", function()
  vim.wo.spell = not vim.wo.spell
end, "Toggle spell")

map("n", "<leader>tw", function()
  vim.wo.wrap = not vim.wo.wrap
  vim.wo.linebreak = vim.wo.wrap
end, "Toggle wrap")

-- Encourage hjkl (your style)
map("n", "<Up>",    function() vim.notify("Use k ya!") end)
map("n", "<Down>",  function() vim.notify("Use j ya!") end)
map("n", "<Left>",  function() vim.notify("Use h ya!") end)
map("n", "<Right>", function() vim.notify("Use l ya!") end)

-- Terminal: make <Esc> leave terminal-mode
map("t", "<Esc>", [[<C-\><C-n>]], "Exit terminal mode")

----------------------------------------------------
-- Telescope (if present)
----------------------------------------------------
local tb = try_require("telescope.builtin")
if tb then
  map("n", "<leader>f",  tb.find_files,                 "Files")
  map("n", "<leader>b",  tb.buffers,                    "Buffers")
  map("n", "<leader>g",  tb.live_grep,                  "Live grep")
  map("n", "<leader>w",  tb.current_buffer_fuzzy_find,  "Fuzzy in buffer")
  map("n", "<leader>fh", tb.help_tags,                  "Help tags")
end

----------------------------------------------------
-- Plugin UIs & helpers (if present)
----------------------------------------------------
-- lazy.nvim UI
map("n", "<leader>lz", "<cmd>Lazy<cr>", "Open lazy.nvim UI")

-- which-key (optional: quickly show)
if try_require("which-key") then
  map("n", "<leader>?", "<cmd>WhichKey<cr>", "Show key hints")
end

-- Markdown preview (only for Markdown buffers)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- These are no-ops if the plugin isn't installed
    map("n", "<leader>mp", "<cmd>MarkdownPreview<cr>",      "Markdown preview")
    map("n", "<leader>ms", "<cmd>MarkdownPreviewStop<cr>",  "Markdown preview stop")
  end,
})

----------------------------------------------------
-- Diagnostics (built-in LSP, harmless if LSP not attached)
----------------------------------------------------
map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
map("n", "<leader>e", vim.diagnostic.open_float, "Line diagnostics")
map("n", "<leader>dq", vim.diagnostic.setloclist, "Diagnostics to loclist")

-- Optional LSP buffer-local mappings when a server attaches
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local function bmap(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
    end
    bmap("n", "gd", vim.lsp.buf.definition,        "Go to definition")
    bmap("n", "gD", vim.lsp.buf.declaration,       "Go to declaration")
    bmap("n", "gi", vim.lsp.buf.implementation,    "Go to implementation")
    bmap("n", "gr", vim.lsp.buf.references,        "References")
    bmap("n", "K",  vim.lsp.buf.hover,             "Hover")
    bmap("n", "<leader>rn", vim.lsp.buf.rename,    "Rename symbol")
    bmap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    bmap("n", "<leader>fm", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
  end,
})
