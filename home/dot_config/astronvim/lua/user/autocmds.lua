vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "Cargo.toml" },
  callback = function(event)
    local bufnr = event.buf
    local wk = require "which-key"

    wk.register({
      c = {
        name = "Crates",
        y = { "<cmd>lua require'crates'.open_repository()<cr>", "Open Repository" },
        p = { "<cmd>lua require'crates'.show_popup()<cr>", "Show Popup" },
        i = { "<cmd>lua require'crates'.show_crate_popup()<cr>", "Show Info" },
        f = { "<cmd>lua require'crates'.show_features_popup()<cr>", "Show Features" },
        d = { "<cmd>lua require'crates'.show_dependencies_popup()<cr>", "Show Dependencies" },
      },
    }, {
      prefix = "<leader>l",
      buffer = bufnr,
    })
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*.rs" },
  callback = function(event)
    local bufnr = event.buf
    local wk = require "which-key"

    wk.register({
      e = { "<cmd>RustRunnables<cr>", "Runnables" },
      E = { "<cmd>RustDebuggables<cr>", "Debuggables" },
      l = { function() vim.lsp.codelens.run() end, "Code Lens" },
      -- t = { "<cmd>Cargo test<cr>", "Cargo test" },
      -- R = { "<cmd>Cargo run<cr>", "Cargo run" },
    }, {
      prefix = "<leader>l",
      buffer = bufnr,
    })
  end,
})

-- vim.api.nvim_create_autocmd("User", {
--   desc = "Auto hide tabline",
--   group = vim.api.nvim_create_augroup("autohide_tabline", { clear = true }),
--   pattern = "AstroBufsUpdated",
--   callback = function()
--     local new_showtabline = #vim.t.bufs > 1 and 2 or 1
--     if new_showtabline ~= vim.opt.showtabline:get() then vim.opt.showtabline = new_showtabline end
--   end,
-- })
