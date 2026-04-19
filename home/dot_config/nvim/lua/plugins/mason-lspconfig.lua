return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bacon_ls = { mason = false },
        bashls = { mason = false },
        gopls = { mason = false },
        vtsls = { mason = false },
        terraformls = { mason = false },
        kotlin_language_server = { mason = false },
        yamlls = { mason = false },
        jsonls = { mason = false },
      },
    },
  },
}

-- return {
--   {
--     "mason-org/mason-lspconfig.nvim",
--     opts = {
--       automatic_installation = {
--         exclude = {
--           "bashls",
--           "yamlls",
--           "jsonls",
--           "bacon-ls",
--         },
--       },
--     },
--   },
-- }
