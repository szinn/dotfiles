return {
  'nvim-lualine/lualine.nvim', -- Fancier statusline
  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    }
  end
}

