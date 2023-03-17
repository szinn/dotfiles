local opts = {
  colorscheme = function()
    require("tokyonight").load()
  end,
}

require("config").setup(opts)
