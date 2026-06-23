km = vim.keymap

-- Change leader to a space
vim.g.mapleader = ' '

km.set('n', '<leader>l', ':Lazy<CR>')

-- Commands with one fewer keystroke - swap ; and :
km.set('n', ';', ':')
km.set('n', ':', ';')

-- Clear search highlighting with <leader> and ,
km.set('n', '<leader>,', ':nohl<CR>')

-- -- Start a search with <leader> and /
-- km.set('n', '<leader>/', ':silent grep<space>')
-- km.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")

-- Switch back to most recent buffer
km.set('n', '<BS>', ':b#<CR>')

-- Quickfix 
km.set('n', '<UP>', ':cope<CR>', { silent = true })
km.set('n', '<DOWN>', ':cclose<CR>', { silent = true })
km.set('n', '<leader>cn', ':cnext<CR>', { silent = true })
km.set('n', '<leader>cp', ':cprev<CR>', { silent = true })
km.set('n', '<RIGHT>', ':cnext<CR>', { silent = true })
km.set('n', '<LEFT>', ':cprev<CR>', { silent = true })


--  Copy/Paste from register
km.set('n', '<leader>cc', ':%y+<CR>') -- copy entire buffer into system clipboard
km.set('v', '<leader>cc', '"*y')
km.set({'n', 'v'}, '<leader>vv', '"*p')

-- Move around splits using Ctrl + {h,j,k,l}
-- km.set('n', '<C-h>', '<C-w>h', { silent = true })
-- km.set('n', '<C-j>', '<C-w>j', { silent = true })
-- km.set('n', '<C-k>', '<C-w>k', { silent = true })
-- km.set('n', '<C-l>', '<C-w>l', { silent = true })
-- km.set('n', '<C-h>', ':wincmd h<CR>', { silent = true })
-- km.set('n', '<C-j>', ':wincmd j<CR>', { silent = true })
-- km.set('n', '<C-k>', ':wincmd k<CR>', { silent = true })
-- km.set('n', '<C-l>', ':wincmd l<CR>', { silent = true })
--nmap <silent> <c-k> :wincmd k<CR>
--nmap <silent> <c-j> :wincmd j<CR>
--nmap <silent> <c-h> :wincmd h<CR>
--nmap <silent> <c-l> :wincmd l<CR>


-- Close all windows and exit from Neovim with <leader> and q
km.set('n', '<leader>q', ':qa!<CR>')

-- Quit with one fewer keystroke
km.set('n', '<leader>w', ':wq<CR>')

-- Whitespace
km.set('n', '<leader><leader>', ':%s/ \\+$//g<CR>')

-----------------------------------------------------------
-- Applications and Plugins shortcuts
-----------------------------------------------------------

-- -- NvimTree
-- km.set('n', '<leader>\\', ':NvimTreeToggle<CR>')       -- open/close
-- -- km.set('n', '<leader>f', ':NvimTreeRefresh<CR>')       -- refresh
-- km.set('n', '<leader>n', ':NvimTreeFindFile<CR>')      -- search file

-- Telescope
km.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
km.set('n', '<leader>p', '<cmd>Telescope find_files<cr>')

km.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>') -- (f)ind (g)rep
km.set('n', '<leader>fp', '<cmd>Telescope live_grep<cr>') -- (f)ind in (p)roject
km.set('n', '<leader>/', '<cmd>Telescope live_grep<cr>') -- (f)ind in (p)roject

km.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
km.set('n', '<leader>b', '<cmd>Telescope buffers<cr>')

km.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')
km.set('n', '<leader>fu', '<cmd>Telescope undo<cr>')
km.set('n', '<leader>u', '<cmd>Telescope undo<cr>')

-- Git
km.set('n', '<leader>g', ':G')
km.set('n', '<leader>gs', ':G<CR>')
km.set('n', '<leader>gc', ':Gcommit<CR>')
km.set('n', '<leader>gd', ':Gdiff<CR>')
km.set('n', '<leader>gb', ':Git blame<CR>')
km.set('n', '<leader>gh', ':Git push<CR>')
km.set('n', '<leader>g>', ':GitGutterNextHunk<CR>')
km.set('n', '<leader>g<', ':GitGutterPrevHunk<CR>')
km.set('n', '<leader>gw', ':Gwrite<CR>')
km.set('n', '<leader>gr', ':Gread<CR>')
km.set('n', '<leader>gl', ':Glog<CR>')
km.set('n', '<leader>gh', ':0Glog<CR>')
km.set('n', '<leader>g-', ':GitGutterUndoHunk<CR>')
km.set('n', '<leader>g+', ':GitGutterStageHunk<CR>')
