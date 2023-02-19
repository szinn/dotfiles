return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 
      'nvim-lua/plenary.nvim' 
    }
  },
  { 'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = vim.fn.executable 'make' == 1
  },

  { 'folke/tokyonight.nvim' },
  {
    'folke/trouble.nvim',
    config = function(plugin)
      require("trouble").setup {
        icons = false,
      }
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    }
  },

  { 'nvim-treesitter/playground' },
  { 'theprimeagen/harpoon' },
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-sleuth' },
  { 'nvim-treesitter/nvim-treesitter-context' },
  { 'lukas-reineke/indent-blankline.nvim' },

  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    dependencies = {
      -- LSP Support
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Autocompletion
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',

      -- Snippets
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
    }
  },
}
