return {
  {
    "jayp0521/mason-nvim-dap.nvim",
    lazy = true,
    dependencies = {
      "mason.nvim",
      "mfussenegger/nvim-dap",
    },
    keys = {
        { "<F5>", function() require'dap'.continue() end, desc = "Continue" },
        { "<F10>", function() require'dap'.step_over() end, desc = "Step Over" },
        { "<F11>", function() require'dap'.step_into() end, desc = "Step Into" },
        { "<F12>", function() require'dap'.step_out() end, desc = "Step Out" },
        { "<Leader>db", function() require'dap'.toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        { "<Leader>dB", function() require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
        { "<Leader>dr", function() require'dap'.repl.open() end, desc = "Open Repl" },
        { "<Leader>dl", function() require'dap'.run_last() end, desc = "Run Last" }
    },
    config = function ()
      require('mason-nvim-dap').setup {
        automatic_installation = true,
        automatic_setup = true,
      }

      local dap = require'dap'

      require'mason-nvim-dap'.setup_handlers({
        function (source_name)
          -- all sources with no handler get passed here
          require('mason-nvim-dap.automatic_setup')(source_name)
        end,
        codelldb = function(source_name)
          dap.adapters.codelldb = {
            type = 'server',
            port = "${port}",
            executable = {
              command = 'codelldb',
              args = {"--port", "${port}" }
            }
          }
          dap.configurations.cpp = {
            {
              name = "Launch file",
              type = "codelldb",
              request = "launch",
              program = function()
                print("Compiling Current File for Debug")
                print("File Name: " .. vim.fn.expand("%"))
                os.execute('g++ -g ' .. vim.fn.expand("%") .. " -o " .. vim.fn.expand("%:r") .. "DEBUG" )
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
              end,
              cwd = '${workspaceFolder}',
            },
          }
        end
      })

      local sign = vim.fn.sign_define
      sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = ""})
      sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = ""})
      sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = ""})

    end,
    init = function()
      local wk = require("which-key")
      wk.register({
        ["<Leader>d"] = { name = "DAP" },
      })
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    keys = {
      {"<leader>do", function() require('dapui').open() end, desc = "Open Dap UI"},
      {"<leader>dc", function() require('dapui').close() end, desc = "Close Dap UI"}
    },
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function ()
      require("dapui").setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        -- Expand lines larger than the window
        -- Requires >= 0.7
        expand_lines = vim.fn.has("nvim-0.7"),
        -- Layouts define sections of the screen to place windows.
        -- The position can be "left", "right", "top" or "bottom".
        -- The size specifies the height/width depending on position. It can be an Int
        -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
        -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
        -- Elements are the elements shown in the layout (in order).
        -- Layouts are opened in order so that earlier layouts take priority in window sizing.
        layouts = {
          {
            elements = {
              -- Elements can be strings or table with id and size keys.
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40, -- 40 columns
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25, -- 25% of total lines
            position = "bottom",
          },
        },
        floating = {
          max_height = nil, -- These can be integers or a float between 0 and 1.
          max_width = nil, -- Floats will be treated as percentage of your screen.
          border = "single", -- Border style. Can be "single", "double" or "rounded"
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil, -- Can be integer or nil.
          max_value_lines = 100, -- Can be integer or nil.
        }
      })
    end,
  }
}

