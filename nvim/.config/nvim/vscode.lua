-- ===================
-- vscode.lua — loaded by vscode-neovim instead of init.lua
-- Settings and keymaps only; no plugins (VSCode handles all of that)
-- ===================

-- ===================
-- Settings (mirror init.lua)
-- ===================
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.scrolloff = 30

-- Clear search highlight with Esc
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- ===================
-- Keymaps
-- ===================
local vscode = require('vscode')

-- Ctrl+A to select all
vim.keymap.set('n', '<C-a>', 'ggVG')

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<Up>',    '<Nop>')
vim.keymap.set('n', '<Down>',  '<Nop>')
vim.keymap.set('n', '<Left>',  '<Nop>')
vim.keymap.set('n', '<Right>', '<Nop>')

-- Tab navigation → VSCode editor tabs
for i = 1, 9 do
  vim.keymap.set('n', '<leader>' .. i, function()
    vscode.call('workbench.action.openEditorAtIndex' .. i)
  end)
end
vim.keymap.set('n', '<leader>0', function()
  vscode.call('workbench.action.lastEditorInGroup')
end)

-- File navigation (telescope equivalents → VSCode)
vim.keymap.set('n', '<leader>ff', function() vscode.call('workbench.action.quickOpen') end)
vim.keymap.set('n', '<leader>fg', function() vscode.call('workbench.action.findInFiles') end)
vim.keymap.set('n', '<leader>fr', function() vscode.call('workbench.action.openRecent') end)
vim.keymap.set('n', '<leader>fb', function() vscode.call('workbench.action.showAllEditors') end)

-- LSP (VSCode LSP)
vim.keymap.set('n', 'gd',          function() vscode.call('editor.action.revealDefinition') end)
vim.keymap.set('n', 'gr',          function() vscode.call('editor.action.goToReferences') end)
vim.keymap.set('n', 'K',           function() vscode.call('editor.action.showHover') end)
vim.keymap.set('n', '<leader>rn',  function() vscode.call('editor.action.rename') end)
vim.keymap.set('n', '<leader>ca',  function() vscode.call('editor.action.quickFix') end)
vim.keymap.set('n', '[d',          function() vscode.call('editor.action.marker.prevInFiles') end)
vim.keymap.set('n', ']d',          function() vscode.call('editor.action.marker.nextInFiles') end)

-- Git hunks (VSCode SCM)
vim.keymap.set('n', ']c',          function() vscode.call('workbench.action.editor.nextChange') end)
vim.keymap.set('n', '[c',          function() vscode.call('workbench.action.editor.previousChange') end)
vim.keymap.set('n', '<leader>hp',  function() vscode.call('editor.action.dirtydiff.next') end)
vim.keymap.set('n', '<leader>hr',  function() vscode.call('git.revertSelectedRanges') end)
vim.keymap.set('n', '<leader>hb',  function() vscode.call('gitlens.toggleLineBlame') end)

-- Sidebar / file tree (VSCode Explorer)
vim.keymap.set('n', '<leader>n',   function() vscode.call('workbench.action.toggleSidebarVisibility') end)
vim.keymap.set('n', '<leader>e',   function() vscode.call('workbench.view.explorer') end)

-- Splits
vim.keymap.set('n', '<leader>wv',  function() vscode.call('workbench.action.splitEditorRight') end)
vim.keymap.set('n', '<leader>ws',  function() vscode.call('workbench.action.splitEditorDown') end)
vim.keymap.set('n', '<leader>wq',  function() vscode.call('workbench.action.closeActiveEditor') end)

-- Split navigation (Ctrl+hjkl)
vim.keymap.set('n', '<C-h>',       function() vscode.call('workbench.action.focusLeftGroup') end)
vim.keymap.set('n', '<C-j>',       function() vscode.call('workbench.action.focusBelowGroup') end)
vim.keymap.set('n', '<C-k>',       function() vscode.call('workbench.action.focusAboveGroup') end)
vim.keymap.set('n', '<C-l>',       function() vscode.call('workbench.action.focusRightGroup') end)

-- Terminal toggle
vim.keymap.set('n', '<leader>t',   function() vscode.call('workbench.action.terminal.toggleTerminal') end)
vim.keymap.set('n', '<leader>k',   function() vscode.call('workbench.action.terminal.toggleTerminal') end)