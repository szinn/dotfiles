return {
  {
    "gbprod/yanky.nvim",
    event = "VeryLazy",
    opts = {
      highlight = { timer = 150 },
    },
    keys = {
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before" },
      { "<c-n>", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
      { "<c-p>", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
      -- { "<leader>y", "<cmd>Telescope yank_history<cr>", desc = "Yank history" },
    },
    config = function(_, opts)
      require("yanky").setup(opts)
      -- require("telescope").load_extension("yank_history")
    end,
  },
}
