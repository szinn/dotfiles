-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")
local wk = require("which-key")

-- delete
vim.keymap.del("n", "<leader>l")

-- Comment
if Util.has("Comment.nvim") then
  wk.register({
    ["/"] = {
      function()
        require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1)
      end,
      "Comment line"
    },
  }, {
    mode = "n",
    prefix = "<leader>",
  })
  wk.register({
    ["/"] = { "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", "Comment block" },
  }, {
    mode = "v",
    prefix = "<leader>",
  })
end

-- Package manager (Lazy)
wk.register({
  p = {
    name = "Package",
    i = { function() require("lazy").install() end, "Plugins Install" },
    s = { function() require("lazy").home() end, "Plugins Status" },
    S = { function() require("lazy").sync() end, "Plugins Sync" },
    u = { function() require("lazy").check() end, "Plugins Check Updates" },
    U = { function() require("lazy").update() end, "Plugins Update" },
  },
}, {
  prefix = "<leader>"
})

-- Mason
if Util.has("mason.nvim") then
  wk.register({
    p = {
      m = { "<cmd>Mason<cr>", "Mason Installer" },
    },
  }, {
    prefix = "<leader>"
  })
end

-- Telescope
wk.register({
  g = {
    b = { function() require("telescope.builtin").git_branches() end, "Git Branches" },
  },
}, {
  prefix = "<leader>"
})
