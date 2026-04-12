-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
if vim.g.vscode then
  return
end

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("i", "jl", "<Esc>", { noremap = false })

-- Move to center of screen too
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)
keymap("n", "<C-f>", "<C-f>zz", opts)
keymap("n", "<C-b>", "<C-b>zz", opts)

-- Insights picker
vim.keymap.set("n", "<leader>fi", function()
  Snacks.picker.files({
    cwd = vim.fn.getcwd() .. "/.insights",
    args = { "--follow", "--exclude", "searchable" },
  })
end, { desc = "Find insights files" })

vim.keymap.set("n", "<leader>si", function()
  Snacks.picker.grep({
    cwd = vim.fn.getcwd() .. "/.insights",
    args = { "--follow", "--glob", "!searchable/**" },
  })
end, { desc = "Grep insights" })
