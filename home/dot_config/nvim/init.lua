-- https://medium.com/@nikmas_dev/vscode-neovim-setup-keyboard-centric-powerful-reliable-clean-and-aesthetic-development-582d34297985
if vim.g.vscode then
    -- running neovim in VSCode
    require("config.vscode_keymaps")
else
    -- bootstrap lazy.nvim, LazyVim and your plugins
    require("config.lazy")
end
