return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },

      blame_line = {
        win = {
          relative = "cursor",
          width = 0.6,
          height = 0.6,
          border = vim.o.winborder --[[@as "rounded"|"single"|"double"|"solid"]],
          title = " 󰆽 Git blame ",
        },
      },

      dashboard = { enabled = true },

      explorer = {
        enabled = true,
        replace_netrw = true,
      },

      indent = {
        enabled = true,
        char = "│",
        scope = { hl = "Comment" },
        chunk = {
          enabled = false,
          hl = "Comment",
        },
        animate = {
          -- slower for more dramatic effect :D
          enabled = false,
          duration = { steps = 200, total = 1000 },
        },
      },

      input = {
        enabled = true,
      },

      notifier = {
        enabled = true,
        timeout = 3000,
      },

      picker = {
        hidden = true,
        sources = {
          explorer = {
            auto_close = true,
            layout = "ivy",
            -- layout = "small_no_preview",
          },
          files = {
            exclude = { ".git", ".jj", ".DS_Store" },
            layout = "ivy",
            -- layout = "wide_with_preview",
          },
          todo_comments = {
            hidden = false,
            ignored = false,
          },
        },

        layout = "ivy",
        -- layout = "wide_with_preview",

        layouts = { -- define available layouts
          small_no_preview = {
            layout = {
              box = "horizontal",
              width = 0.6,
              height = 0.6,
              border = "none",
              {
                box = "vertical",
                border = vim.o.winborder --[[@as "rounded"|"single"|"double"|"solid"]],
                title = "{title} {live} {flags}",
                { win = "input", height = 1, border = "bottom" },
                { win = "list", border = "none" },
              },
            },
          },
          wide_with_preview = {
            preset = "small_no_preview", -- inherit from this preset
            layout = {
              width = 0.99,
              [2] = { -- as second column
                win = "preview",
                title = "{preview}",
                border = vim.o.winborder --[[@as "rounded"|"single"|"double"|"solid"]],
                width = 0.5,
                wo = { number = false, statuscolumn = " ", signcolumn = "no" },
              },
            },
          },
        },
      },

      quickfile = { enabled = true },

      scope = { enabled = true },

      scroll = { enabled = true },

      statuscolumn = { enabled = false },

      words = {
        enabled = true,
        notify_jump = true,
        modes = { "n" },
        debounce = 300,
      },

      zen = { enabled = true },
    },

    -- stylua: ignore
    keys = {
      { "<leader>e", function() Snacks.explorer() end, desc = "Explorer" },
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>bz", function() Snacks.zen() end, desc = "Toggle Zen Mode", mode = "n" },
    },
  },
}
