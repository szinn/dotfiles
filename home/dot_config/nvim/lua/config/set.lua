local opt = vim.opt
local g = vim.g

opt.guicursor = ""

opt.nu = true
opt.relativenumber = false

g.tabstop = 2
g.softtabstop = 2
g.shiftwidth = 2
g.expandtab = true

opt.smartindent = true

opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")

opt.updatetime = 50

opt.colorcolumn = "120"
