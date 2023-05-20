return {
  "kdheepak/lazygit.nvim",
  lazy = false,
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  },
  config = function()
    require("telescope").load_extension "lazygit"
    vim.g.lazygit_config_file_path = vim.env.HOME .. "/.config/lazygit/config.yml"
  end,
}
