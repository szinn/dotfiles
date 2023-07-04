return {
  -- {
  --   "neovim/nvim-lspconfig",
  --   ---@class PluginLspOpts
  --   opts = {
  --     ---@type lspconfig.options
  --     servers = {
  --       -- sourcekit will be automatically installed with mason and loaded with lspconfig
  --       sourcekit = {},
  --     },
  --   },
  -- },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "lua-language-server", "marksman" })
      opts.ui = {
        icons = {
          package_installed = "✓",
          package_pending = "",
          package_uninstalled = "✗",
        },
      }
    end,
  },

  { "rcarriga/nvim-dap-ui" },

  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.dap.nlua" },
  { import = "plugins.extras.lang.rust" },
  { import = "plugins.extras.lang.terraform" },
}
