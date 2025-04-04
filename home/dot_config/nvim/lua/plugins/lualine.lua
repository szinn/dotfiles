return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local opts = {
        sections = {
          lualine_z = {
            " ",
          },
        },
      }

      return opts
    end,
  },
}
