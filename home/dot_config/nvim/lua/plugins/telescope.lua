local M = {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  branch = "0.1.x",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-file-browser.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  }
}

function M.init()
  vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files find_command=rg,--ignore,--files<CR>")
  vim.keymap.set("n", "<leader>e", "<cmd>Telescope file_browser<CR>")
  vim.keymap.set("n", "<leader>F", "<cmd>Telescope oldfiles<CR>")
  vim.keymap.set("n", "<leader>s", "<cmd>Telescope current_buffer_fuzzy_find<CR>")
  vim.keymap.set("n", "<leader>S", "<cmd>Telescope live_grep<CR>")
  vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>")
end

function M.config()
  local telescope = require("telescope")

  telescope.load_extension("fzf")
  telescope.load_extension("file_browser")
end

return M
