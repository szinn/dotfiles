return {
  {
    'folke/snacks.nvim',
    opts = {
      explorer = {
        replace_netrw = true,
      },
    },
    keys = {
      {
        '<leader>e',
        function()
          Snacks.explorer()
        end,
        desc = 'Explorer',
      },
    },
  },
}
