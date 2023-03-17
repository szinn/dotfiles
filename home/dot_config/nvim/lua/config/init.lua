local M = {}

local defaults = {
  colorscheme = function()
    require("tokyonight").load()
  end,
}

local options

function M.setup(opts)
  options = vim.tbl_deep_extend("force", defaults, opts or {})

  require("config.options")
  require("config.lazy")

  if vim.fn.argc(-1) == 0 then
    -- autocmds and keymaps can wait to load
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        require("config.autocmds")
        require("config.keymaps")
      end,
    })
  else
    -- load now as they affect opened buffers
    require("config.autocmds")
    require("config.keymaps")
  end

  if type(M.colorscheme) == "function" then
    M.colorscheme()
  else
    vim.cmd.colorscheme(M.colorscheme)
  end
end

setmetatable(M, {
  __index = function(_, key)
    if options == nil then
      return vim.deepcopy(defaults)[key]
    end
    return options[key]
  end,
})

return M
