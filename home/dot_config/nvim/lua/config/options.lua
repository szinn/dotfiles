-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
if vim.g.vscode then
  return
end

-- Set moonfly theme fg/bg for floating windows
vim.g.moonflyNormalFloat = true

-- Set to use single boarder for windows
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
--   border = "single",
-- })
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, {
--   border = "single",
-- })
-- vim.diagnostic.config({ float = { border = "single" } })

--------------------------------------------------------------------------------
-- GENERAL

vim.opt.undofile = true -- enables persistent undo history
vim.opt.undolevels = 1337 -- too high results in increased buffer loading time
vim.opt.swapfile = false -- doesn't help and only creates useless files and notifications

vim.opt.spell = false
-- vim.opt.spellfile = vim.fs.normalize("~/.config/+ linter-configs/spellfile.add") -- needs `.add` ext
vim.opt.spelllang = "en_us" -- even with spellcheck disabled, still relevant for `z=`
vim.opt.spelloptions = "camel"

vim.opt.splitright = true -- split right instead of left
vim.opt.splitbelow = true -- split down instead of up

vim.opt.cursorline = true
vim.opt.colorcolumn = "+1" -- = one more than textwidth
vim.opt.signcolumn = "yes:2" -- too many potential signs for just `1`

vim.opt.wrap = false

vim.opt.shortmess:append("ISs") -- no intro message, disable search count
vim.opt.report = 9001 -- disable most "x more/fewer lines" messages

vim.opt.iskeyword:append("-") -- treat `-` as word character, same as `_`

-- treat all numbers as positive, ignoring dashes
-- this also makes `<C-x>` stop at `0`
vim.opt.nrformats = { "unsigned" }

vim.opt.autowriteall = true

vim.opt.jumpoptions:append("stack") -- https://www.reddit.com/r/neovim/comments/16nead7/comment/k1e1nj5/?context=3
vim.opt.startofline = true -- motions like "G" also move to the first char

vim.opt.timeoutlen = 666

-- Formatting `vim.opt.formatoptions:remove("o")` would not work, since it's
-- overwritten by ftplugins having the `o` option (which many do). Therefore
-- needs to be set via autocommand.
vim.api.nvim_create_autocmd("FileType", {
  desc = "User: Remove `o` from `formatoptions`",
  callback = function(ctx)
    if ctx.match ~= "markdown" then
      vim.opt_local.formatoptions:remove("o")
      vim.opt_local.formatoptions:remove("t")
    end
  end,
})

--------------------------------------------------------------------------------
-- APPEARANCE

vim.opt.sidescrolloff = 15
vim.opt.scrolloff = 12

-- max height of completion menu (even with completion plugin still relevant for native cmdline-popup)
vim.opt.pumheight = 12

--------------------------------------------------------------------------------
-- CLIPBOARD
--
-- opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "User: Highlighted Yank",
  callback = function()
    vim.highlight.on_yank({ timeout = 1000 })
  end,
})

--------------------------------------------------------------------------------
-- EDITORCONFIG

-- mostly set by `editorconfig`, therefore only fallback
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.opt.shiftround = true

--------------------------------------------------------------------------------
-- SEARCH & CMDLINE

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cmdheight = 0 -- overwritten by `noice.nvim` setting it 0
vim.opt.smartindent = true

--------------------------------------------------------------------------------
-- FOLDING

vim.opt.foldlevel = 99 -- do not auto-fold
vim.opt.foldlevelstart = 99
vim.opt.foldtext = "" -- empty string keeps text (overwritten by nvim-origami)

-- fold with LSP/Treesitter
do
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "User: Set LSP folding if client supports it",
    callback = function(ctx)
      local client = assert(vim.lsp.get_client_by_id(ctx.data.client_id))
      if client:supports_method("textDocument/foldingRange") then
        local win = vim.api.nvim_get_current_win()
        vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
      end
    end,
  })
end

--------------------------------------------------------------------------------
-- DIAGNOSTICS

vim.diagnostic.config({
  jump = {
    float = true,
  },
  signs = {
    text = { "", "▲", "●", "" }, -- Error, Warn, Info, Hint
  },
  virtual_text = {
    spacing = 2,
    severity = {
      min = vim.diagnostic.severity.WARN, -- leave out Info & Hint
    },
    format = function(diag)
      local msg = diag.message:gsub("%.$", "")
      return msg
    end,
    suffix = function(diag)
      if not diag then
        return ""
      end
      local codeOrSource = (tostring(diag.code or diag.source or ""))
      if codeOrSource == "" then
        return ""
      end
      return (" [%s]"):format(codeOrSource:gsub("%.$", ""))
    end,
  },
  float = {
    max_width = 70,
    header = "",
    prefix = function(_, _, total)
      return (total > 1 and "• " or ""), "Comment"
    end,
    suffix = function(diag)
      local source = (diag.source or ""):gsub(" ?%.$", "")
      local code = diag.code and ": " .. diag.code or ""
      return " " .. source .. code, "Comment"
    end,
    format = function(diag)
      local msg = diag.message:gsub("%.$", "")
      return msg
    end,
  },
})

--------------------------------------------------------------------------------
-- RUST

vim.g.lazyvim_rust_diagnostics = "bacon-ls"
