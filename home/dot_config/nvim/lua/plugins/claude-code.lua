return {
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("claude-code").setup()
    end,
    keys = {
      { "<leader>ck", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
    },
  },
}
