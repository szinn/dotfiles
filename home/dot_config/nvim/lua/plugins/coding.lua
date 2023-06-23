return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "bash",
          "comment",
          "go",
          "json",
          "jsonc",
          "lua",
          "luadoc",
          "markdown",
          "markdown_inline",
          "rust",
          "toml",
          "terraform",
          "yaml",
        })
      end
    end,
  },
}
