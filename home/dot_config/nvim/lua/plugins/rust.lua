return {
  {
    "simrat39/rust-tools.nvim",
    event = "BufReadPre",
    config = function()
      local rt = require("rust-tools")

      rt.setup({
        server = {
          on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- Code action groups
            vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
      })

      -- LSP Diagnostics Options Setup
      local sign = function(opts)
        vim.fn.sign_define(opts.name, {
          texthl = opts.name,
          text = opts.text,
          numhl = "",
        })
      end

      sign({ name = "DiagnosticSignError", text = "" })
      sign({ name = "DiagnosticSignWarn", text = "" })
      sign({ name = "DiagnosticSignHint", text = "" })
      sign({ name = "DiagnosticSignInfo", text = "" })

      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        update_in_insert = true,
        underline = true,
        severity_sort = false,
        float = {
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      vim.cmd([[
      set signcolumn=yes
      autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
      ]])
    end,
  },
  {
    "nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/vim-vsnip",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      }
      opts.mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        -- Add tab support
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<C-S-f>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),
      }
      opts.window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      }
      opts.formatting = {
        fields = { "menu", "abbr", "kind" },
        format = function(entry, item)
          local menu_icon = {
            nvim_lsp = "λ",
            vsnip = "⋗",
            buffer = "Ω",
            path = "🖫",
          }
          item.menu = menu_icon[entry.source.name]
          return item
        end,
      }
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "emoji" },
        { name = "path" }, -- file paths
        { name = "nvim_lsp", keyword_length = 3 }, -- from language server
        { name = "nvim_lsp_signature_help" }, -- display function signatures with current parameter emphasized
        { name = "nvim_lua", keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
        { name = "buffer", keyword_length = 2 }, -- source current buffer
        { name = "vsnip", keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
        { name = "calc" }, -- source for math calculation
      }))
    end,
  },
  {
    "puremourning/vimspector",
    event = "BufReadPre",
    keys = {
      { "<F9>", "<cmd>call vimspector#Launch()<cr>", desc = "Debug" },
      { "<F5>", "<cmd>call vimspector#StepOver()<cr>", desc = "Step Over" },
      { "<F6>", "<cmd>call vimspector#Continue()<cr>", desc = "Continue" },
      { "<F8>", "<cmd>call vimspector#Reset()<cr>", desc = "Reset" },
      { "<F11>", "<cmd>call vimspector#StepOver()<cr>", desc = "Step Over" },
      { "<F12>", "<cmd>call vimspector#StepOut()<cr>", desc = "Step Out" },
      { "<F10>", "<cmd>call vimspector#StepInto()<cr>", desc = "Step Into" },
      { "Db", "<cmd>call vimspector#ToggleBreakpoint()<cr>", desc = "Toggle Breakpoint" },
      { "Dw", "<cmd>call vimspector#AddWatch()<cr>", desc = "Add Watch" },
      { "De", "<cmd>call vimspector#Evaluate()<cr>", desc = "Evaluate" },
    },
  },
}
