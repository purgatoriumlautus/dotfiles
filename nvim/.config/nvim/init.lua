if vim.g.vscode then dofile(vim.fn.stdpath('config') .. '/vscode.lua') return end

-- ===================
-- Vim Cheatsheet (advanced)
-- ===================
-- NAVIGATION
--   { / }         jump paragraph up / down
--   Ctrl+d / Ctrl+u   half-page down / up
--   gd            go to definition (LSP)
--   gr            go to references (LSP)
--   Ctrl+o / Ctrl+i   jump back / forward in jump list
--   gi            jump to last insert location
--   gf            open file path under cursor
--   %             jump to matching bracket
--   *             search word under cursor forward
--   #             search word under cursor backward
--
-- TEXT OBJECTS (after d, c, y, v)
--   i) / a)       inside / around ()
--   i] / a]       inside / around []
--   i" / a"       inside / around ""
--   it / at       inside / around HTML tag
--   ip / ap       inside / around paragraph
--
-- POWER EDITS
--   ciw           change word
--   ci"           change inside quotes
--   ci(           change inside parens
--   da)           delete around parens (including them)
--   .             repeat last edit
--   gUiw / guiw   UPPERCASE / lowercase word
--   + / -         increment / decrement number
--   5+            increment by 5
--
-- SURROUND (nvim-surround)
--   ysiw)         wrap word in ()
--   yss)          wrap entire line in ()
--   cs)]          change () to []
--   ds)           delete surrounding ()
--
-- MACROS
--   qa            record into register a
--   q             stop recording
--   @a            replay macro a
--   5@a           replay 5 times
--
-- VISUAL MODE
--   V             select whole line
--   Ctrl+v        block select (columns)
--   I (in block)  insert on all selected lines
--   A (in block)  append on all selected lines
--
-- MARKS
--   ma            set mark a at cursor
--   'a            jump to mark a
--   ''            jump to last position before jump
--
-- REGISTERS
--   "ayiw         yank word into register a
--   "ap           paste from register a
--   :reg          view all registers
--
-- CUSTOM KEYBINDS
--   \n            toggle file tree
--   \e            toggle focus tree/file
--   \ff / \fg     find files / grep project
--   \fb / \fr     buffers / recent files
--   \gd / \gq     open / close diff view
--   \gh / \gH     file history (current / repo)
--   \hp / \hr / \hb   preview / reset / blame hunk
--   ]c / [c       next / prev git hunk
--   ]d / [d       next / prev diagnostic
--   K             hover docs
--   \rn / \ca     rename / code action
--   \t            toggle terminal
--   \?            show all keymaps

-- ===================
-- Mason bin path (for LSP servers)
-- ===================
vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin:' .. vim.env.PATH

-- ===================
-- Settings
-- ===================
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smartindent = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wildmode = 'longest,list'
vim.opt.clipboard = 'unnamedplus'
vim.opt.scrolloff = 30           -- cursor stays centered (your 'so=30')
vim.opt.termguicolors = true     -- needed for modern colorschemes

-- Diagnostic display (LSP errors)
vim.diagnostic.config({
  virtual_text = {                                  -- right-of-line truncated text, errors only
    severity = { min = vim.diagnostic.severity.ERROR },  -- errors only — warnings/info/hints come via popup or gutter sign
    source = 'if_many',                             -- show LSP source name when multiple LSPs attached
    prefix = '■',
  },
  signs = true,                                     -- gutter sign for every diagnostic
  underline = true,                                 -- underline the offending text
  float = { border = 'single', source = true },    -- single-line border for hover/diagnostic floats
})

-- Auto-open diagnostic float after holding cursor on a line for 1.5s
vim.opt.updatetime = 1500  -- ms before CursorHold fires
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

-- Clear search highlight with Esc
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })


-- ===================
-- Keymaps
-- ===================
-- Note: <leader> is backslash by default. Change with: vim.g.mapleader = ' '

-- Ctrl+A to select all
vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select all' })

-- Increment/decrement numbers (+ and - in normal mode)
vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment number' })
vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement number' })

-- Tab navigation (same as your old config)
for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, i .. 'gt', { desc = 'Go to tab ' .. i })
end
vim.keymap.set('n', '<leader>0', ':tablast<CR>', { desc = 'Go to last tab' })

-- Vertical split
vim.keymap.set('n', '<leader>v', '<cmd>vsplit<CR>', { desc = 'Vertical split' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Window right' })

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
if not vim.uv.fs_stat(lazypath) then
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
  -- tresitter for better highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install({'c','python','html','go','bash','dockerfile','yaml','javascript'})
      vim.api.nvim_create_autocmd('FileType',{
        pattern = {'c','python','html','go','sh','dockerfile','yaml','javascript'},
        callback = function()
          vim.treesitter.start()
        end

      })
    end
  },
  -- Colorscheme
  --
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
      { '<leader>ff', function()
          require('telescope.builtin').find_files({
            find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git', '--exclude', '.cache', '.', '/home', '/etc', '/mnt' },
          })
        end, desc = 'Find files in /home /etc /mnt' },
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

  -- Git diff viewer (side-by-side diffs, file history)
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<CR>', desc = 'Open diff view' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = 'File history (current)' },
      { '<leader>gH', '<cmd>DiffviewFileHistory<CR>', desc = 'File history (repo)' },
      { '<leader>gq', '<cmd>DiffviewClose<CR>', desc = 'Close diff view' },
    },
    opts = {},
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


  -- LSP installer
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = function()
      require('mason').setup()
    end,
  },

  -- Autopairs (Rust-powered, replaces nvim-autopairs)
  {
    'saghen/blink.pairs',
    version = '*',
    dependencies = { 'saghen/blink.download' },
    opts = {
      mappings = { enabled = true },
      highlights = { enabled = true },
    },
  },

  -- LSP config
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'saghen/blink.cmp',
    },
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require('blink.cmp').get_lsp_capabilities()

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

          -- Built-in signature help (replaces lsp_signature.nvim)
          vim.api.nvim_create_autocmd('CursorHoldI', {
            buffer = args.buf,
            callback = vim.lsp.buf.signature_help,
          })
        end,
      })

      -- mason-lspconfig auto-setup
      require('mason-lspconfig').setup({
        ensure_installed = { 'clangd', 'pyright', 'bashls', 'yamlls', 'dockerls', 'docker_compose_language_service', 'lua_ls', 'gopls' },
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
                    kubernetes = 'k8s/**/*.yaml',
                  },
                },
              },
            })
          end,
        },
      })
    end,
  },

  -- Completion engine (Rust-powered, replaces nvim-cmp + 5 source plugins)
  {
    'saghen/blink.cmp',
    version = '*',
    lazy = false,
    dependencies = { 'saghen/blink.download' },
    opts = {
      keymap = {
        preset = 'default',
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
      },
      sources = {
        default = { 'lsp', 'snippets', 'buffer', 'path' },
      },
      completion = {
        documentation = { auto_show = true },
      },
    },
  },
  -- Dropdown terminal (toggle with C-`)
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      open_mapping = '<leader>t',
      direction = 'horizontal',
      size = 15,
      shade_terminals = false,
    },
  },

  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup({})
    end,
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show({ global = true })
        end,
        desc = 'All keymaps (which-key)',
      },
    },
  },
})
