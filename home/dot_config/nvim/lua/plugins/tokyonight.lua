local M = {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000
}

function M.config()
  local tokyonight = require("tokyonight")

  tokyonight.setup({
    disable_background = true
  })

  vim.cmd.colorscheme("tokyonight-night")
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return M
