-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
if vim.g.vscode then
  return
end

vim.api.nvim_set_keymap("i", "jl", "<Esc>", { noremap = false })
