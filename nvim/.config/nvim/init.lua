-- ===================
-- Mason bin path (for LSP servers)
-- ===================
vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin:' .. vim.env.PATH

-- ===================
-- Settings
-- ===================
vim.opt.encoding = 'utf-8'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true


vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wildmode = 'longest,list'
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.ttyfast = true
vim.opt.scrolloff = 30           -- cursor stays centered (your 'so=30')
vim.opt.termguicolors = true     -- needed for modern colorschemes

vim.cmd('syntax on')
vim.cmd('filetype plugin indent on')

-- Clear search highlight with Esc
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Auto-restore session (skip with NVIM_NO_SESSION=1 or nvim +NoSession)
vim.api.nvim_create_user_command('NoSession', function()
  vim.g.no_session = true
end, {})

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    -- Skip if NVIM_NO_SESSION=1 or :NoSession was called
    if vim.env.NVIM_NO_SESSION == '1' or vim.g.no_session then
      return
    end

    local args = vim.fn.argc()
    if args == 0 then
      require('persistence').load()
    else
      local files = {}
      for i = 0, args - 1 do
        table.insert(files, vim.fn.argv(i))
      end
      require('persistence').load()
      for _, file in ipairs(files) do
        vim.cmd('tabnew ' .. vim.fn.fnameescape(file))
      end
    end
  end,
  nested = true,
})

-- ===================
-- Keymaps
-- ===================
-- Note: <leader> is backslash by default. Change with: vim.g.mapleader = ' '

-- Ctrl+A to select all
vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select all' })

-- Tab navigation (same as your old config)
for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, i .. 'gt', { desc = 'Go to tab ' .. i })
end
vim.keymap.set('n', '<leader>0', ':tablast<CR>', { desc = 'Go to last tab' })

-- Disable arrow keys in normal mode (use hjkl)
vim.keymap.set('n', '<Up>', '<Nop>')
vim.keymap.set('n', '<Down>', '<Nop>')
vim.keymap.set('n', '<Left>', '<Nop>')
vim.keymap.set('n', '<Right>', '<Nop>')

-- Quit all commands
vim.api.nvim_create_user_command('Q', 'qa!', {})       -- :Q  = quit all (no save)
vim.api.nvim_create_user_command('WQ', 'wqa', {})      -- :WQ = save all + quit
vim.api.nvim_create_user_command('Wq', 'wqa', {})

-- ===================
-- Plugin Manager (lazy.nvim)
-- ===================
-- Bootstrap: auto-install lazy.nvim if not present
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- ===================
-- Plugins
-- ===================
require('lazy').setup({
  -- Colorscheme
  {
    'folke/tokyonight.nvim',
    lazy = false,      -- load immediately
    priority = 1000,   -- load before other plugins
    config = function()
      vim.cmd('colorscheme tokyonight-night')
    end
  },

  -- File explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },  -- file icons
    config = function()
      require('nvim-tree').setup({
        filters = {
          dotfiles = false,
          custom = { 'node_modules', '__pycache__' },  -- same as your old config
        },
        view = {
          width = 30,
        },
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')
          -- Load default mappings first
          api.config.mappings.default_on_attach(bufnr)

          local opts = { buffer = bufnr, noremap = true, silent = true }

          -- Enter opens in new tab (stay in tree)
          vim.keymap.set('n', '<CR>', function()
            api.node.open.tab()
            vim.cmd('tabprev')  -- go back to tree's tab
          end, opts)
          -- o opens in same tab (replace current buffer)
          vim.keymap.set('n', 'o', api.node.open.edit, opts)
          -- Splits
          vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts)
          vim.keymap.set('n', '<C-h>', api.node.open.horizontal, opts)

          -- Vim-like navigation (like yazi)
          vim.keymap.set('n', 'l', api.node.open.edit, opts)        -- enter dir / open file
          vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts)  -- close dir / go up

          -- Change tree root
          vim.keymap.set('n', 'H', api.tree.change_root_to_parent, opts)  -- root up
          vim.keymap.set('n', 'L', api.tree.change_root_to_node, opts)    -- root into dir

          -- Disable arrow keys in tree
          vim.keymap.set('n', '<Up>', '<Nop>', opts)
          vim.keymap.set('n', '<Down>', '<Nop>', opts)
          vim.keymap.set('n', '<Left>', '<Nop>', opts)
          vim.keymap.set('n', '<Right>', '<Nop>', opts)
        end,
      })
    end,
    keys = {
      { '<leader>n', '<cmd>NvimTreeToggle<CR>', desc = 'Toggle file tree' },
      { '<leader>e', function()
          local api = require('nvim-tree.api')
          if vim.bo.filetype == 'NvimTree' then
            vim.cmd('wincmd p')  -- go to previous window
          else
            api.tree.focus()    -- focus tree
          end
        end, desc = 'Toggle focus tree/file' },
    },
  },

  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local actions = require('telescope.actions')
      require('telescope').setup({
        defaults = {
          mappings = {
            i = {  -- insert mode
              ['<CR>'] = actions.select_tab,      -- Enter opens in new tab
              ['<C-v>'] = actions.select_vertical,  -- Ctrl+v vertical split
              ['<C-h>'] = actions.select_horizontal, -- Ctrl+h horizontal split
            },
            n = {  -- normal mode
              ['<CR>'] = actions.select_tab,
              ['<C-v>'] = actions.select_vertical,
              ['<C-h>'] = actions.select_horizontal,
            },
          },
        },
      })
    end,
    keys = {
      { '<leader>ff', '<cmd>Telescope find_files<CR>', desc = 'Find files' },
      { '<leader>fg', '<cmd>Telescope live_grep<CR>', desc = 'Grep in project' },
      { '<leader>fb', '<cmd>Telescope buffers<CR>', desc = 'Open buffers' },
      { '<leader>fr', '<cmd>Telescope oldfiles<CR>', desc = 'Recent files' },
      { '<leader>fh', '<cmd>Telescope help_tags<CR>', desc = 'Search help' },
    },
  },

  -- Better looking tabs
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup({
        options = {
          mode = 'tabs',              -- show tabs, not buffers
          numbers = 'ordinal',        -- show tab numbers (1, 2, 3...)
          separator_style = 'thick',  -- slant separators
          show_buffer_close_icons = false,
          show_close_icon = false,
        },
      })
    end,
  },

  -- Git signs in gutter
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      local gitsigns = require('gitsigns')
      gitsigns.setup({
        signs = {
          add          = { text = '+' },
          change       = { text = '~' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
        },
        on_attach = function(bufnr)
          local opts = { buffer = bufnr }

          -- Navigation between hunks
          vim.keymap.set('n', ']c', gitsigns.next_hunk, opts)
          vim.keymap.set('n', '[c', gitsigns.prev_hunk, opts)

          -- Actions
          vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, opts)
          vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, opts)
          vim.keymap.set('n', '<leader>hb', gitsigns.blame_line, opts)
        end,
      })
    end,
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'tokyonight',
          section_separators = '',
          component_separators = '|',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff' },
          lualine_c = { 'filename' },
          lualine_x = { 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
      })
    end,
  },

  -- Session persistence (like tmux)
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',  -- load before reading a file
    config = function()
      require('persistence').setup({
        dir = vim.fn.stdpath('state') .. '/sessions/',
      })
    end,
    keys = {
      { '<leader>ss', function() require('persistence').load() end, desc = 'Restore session (cwd)' },
      { '<leader>sl', function() require('persistence').load({ last = true }) end, desc = 'Restore last session' },
      { '<leader>sd', function() require('persistence').stop() end, desc = "Don't save session" },
      { '<leader>sD', function()
          local dir = vim.fn.getcwd():gsub('/', '%%')
          local session_file = vim.fn.stdpath('state') .. '/sessions/' .. dir .. '.vim'
          if vim.fn.delete(session_file) == 0 then
            print('Deleted session: ' .. session_file)
          else
            print('No session found for this directory')
          end
        end, desc = 'Delete session for cwd' },
    },
  },

  -- LSP installer
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = function()
      require('mason').setup()
    end,
  },

  -- LSP config
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Keybinds on LSP attach
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local opts = { buffer = args.buf }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        end,
      })

      -- mason-lspconfig auto-setup
      require('mason-lspconfig').setup({
        ensure_installed = { 'pyright', 'bashls', 'yamlls', 'dockerls', 'docker_compose_language_service' },
        handlers = {
          -- Default handler for all servers
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end,
          -- Custom setup for yamlls
          ['yamlls'] = function()
            lspconfig.yamlls.setup({
              capabilities = capabilities,
              settings = {
                yaml = {
                  schemas = {
                    kubernetes = '/*.yaml',
                  },
                },
              },
            })
          end,
        },
      })
    end,
  },

  -- Completion engine
  {
    'hrsh7th/nvim-cmp',
    lazy = false,  -- load immediately
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged },  -- auto-trigger
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 1000 },  -- LSP first
          { name = 'luasnip', priority = 750 },
          { name = 'buffer', priority = 500 },
          { name = 'path', priority = 250 },
        }),
      })
    end,
  },

})
