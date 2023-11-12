return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPre",
    opts = function(_, opts)
      if opts.ensure_installed == nil then
        opts.ensure_installed = { "hcl", "terraform" }
      else
        vim.list_extend(opts.ensure_installed, { "hcl", "terraform" })
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "BufReadPre",
    opts = function(_, opts)
      if opts.ensure_installed == nil then
        opts.ensure_installed = { "terraformls" }
      else
        vim.list_extend(opts.ensure_installed, { "terraformls" })
      end
    end,
  },
  --  {
  --    "jay-babu/mason-null-ls.nvim",
  --    event = "BufReadPre",
  --    opts = function(_, opts)
  --      if opts.ensure_installed == nil then
  --        opts.ensure_installed = { "tflint", "tfsec" }
  --      else
  --        vim.list_extend(opts.ensure_installed, { "tflint", "tfsec" })
  --      end
  --      opts.automatic_installation = true
  --    end,
  --  },
}
