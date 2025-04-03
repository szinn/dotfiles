return {
  {
    "NStefan002/screenkey.nvim",
    lazy = false,
    keys = {
      {
        "<leader>uk",
        function()
          vim.cmd("Screenkey toggle")
        end,
        desc = "Toggle ScreenKey",
      },
    },
  },
}
