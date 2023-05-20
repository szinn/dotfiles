return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    cmd = "Telescope",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    keys = {

    },
    config = function (plugin, opts)
      require("telescope").setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          winblend = 0
        }
      })

      require('telescope').load_extension("harpoon")
    end,
    init = function()
      local wk = require("which-key")
      wk.register({
        t = {
          name = "Telescope",
          r = { require('telescope.builtin').lsp_references, "LSP References" },
          s = { require('telescope.builtin').live_grep, "Live Grep" },
          f = { require("telescope.builtin").find_files, "Find Files" },
          g = { require("telescope.builtin").git_files, "Git Files" },
          k = { require("telescope.builtin").keymaps, "Keymaps" },
          o = { require("telescope.builtin").lsp_document_symbols, "Symbols" },
          b = { require("telescope.builtin").buffers, "Buffers" },
          l = { require("telescope.builtin").resume, "Resume" },
          h = { require("telescope._extensions.marks"), "Marks" }
        },
      }, {
        prefix = "<leader>",
        noremap = true
      })
    end
  }
}
