------------------------------------------------------------
-- General Neovim settings and configuration
------------------------------------------------------------

-- Default options are not included
-- See: https://neovim.io/doc/user/vim_diff.html
-- [2] Defaults - *nvim-defaults*

local g = vim.g       -- Global variables
local opt = vim.opt   -- Set options (global/buffer/windows-scoped)

opt.grepprg = "rg --vimgrep --hidden !.git/"
opt.grepformat = "%f:%l:%c:%m"

opt.shell = "/bin/bash"

opt.undodir = vim.env.HOME .. "/.vimbackups"
opt.undofile = true

------------------------------------------------------------
-- General
------------------------------------------------------------
opt.mouse = 'a'                       -- Enable mouse support
-- opt.clipboard = 'unnamedplus'         -- Copy/paste to system clipboard
opt.swapfile = false                  -- Don't use swapfile
opt.completeopt = 'menuone,noinsert,noselect'  -- Autocomplete options

------------------------------------------------------------
-- Neovim UI
------------------------------------------------------------
opt.number = true           -- Show line number
opt.showmatch = true        -- Highlight matching parenthesis
-- opt.foldmethod = 'marker'   -- Enable folding (default 'foldmarker')
-- opt.colorcolumn = '80'      -- Line lenght marker at 80 columns
opt.splitright = true       -- Vertical split to the right
opt.splitbelow = true       -- Horizontal split to the bottom
opt.ignorecase = true       -- Ignore case letters when search
opt.smartcase = true        -- Ignore lowercase for the whole pattern
opt.linebreak = true        -- Wrap on word boundary
opt.termguicolors = true    -- Enable 24-bit RGB colors
opt.laststatus=3            -- Set global statusline
opt.signcolumn="yes"        -- Always show the "gutter" (for git and lsp)
-- opt.showtabline=2           -- Show tabline at the top

------------------------------------------------------------
-- Tabs, indent
------------------------------------------------------------
opt.expandtab = true        -- Use spaces instead of tabs
opt.shiftwidth = 2          -- Shift 2 spaces when tab
opt.tabstop = 2             -- 1 tab == 2 spaces
opt.smartindent = true      -- Autoindent new lines
opt.list = true
-- opt.lcs = "eol:¬,tab:»·,trail:·"
opt.lcs = "tab:»·,trail:·"


------------------------------------------------------------
-- Memory, CPU
------------------------------------------------------------
opt.hidden = true           -- Enable background buffers
opt.history = 1000          -- Remember N lines in history
opt.lazyredraw = true       -- Faster scrolling
opt.synmaxcol = 240         -- Max column for syntax highlight
opt.updatetime = 250        -- ms to wait for trigger an event

------------------------------------------------------------
-- Startup
------------------------------------------------------------
-- Disable nvim intro
opt.shortmess:append "sI"

-- Disable builtin plugins
local disabled_built_ins = {
   "2html_plugin",
   "getscript",
   "getscriptPlugin",
   "gzip",
   "logipat",
   "netrw",
   "netrwPlugin",
   "netrwSettings",
   "netrwFileHandlers",
   "matchit",
   "tar",
   "tarPlugin",
   "rrhelper",
   "spellfile_plugin",
   "vimball",
   "vimballPlugin",
   "zip",
   "zipPlugin",
   "tutor",
   "rplugin",
   "synmenu",
   "optwin",
   "compiler",
   "bugreport",
   -- "ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
   g["loaded_" .. plugin] = 1
end


-- local global = vim.g
-- local o = vim.opt
--
-- -- Editor options
--
-- -- -- Tabs/spaces
-- -- o.expandtab = true -- In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
-- -- o.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent.
-- -- o.softtabstop = 2
-- -- o.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for.
-- --
-- -- o.number = true -- Print the line number in front of each line
-- -- o.relativenumber = false -- Show the line number relative to the line with the cursor in front of each line.
-- -- o.clipboard = "unnamedplus" -- uses the clipboard register for all operations except yank.
-- -- o.syntax = "on" -- When this option is set, the syntax with this name is loaded.
-- -- o.autoindent = true -- Copy indent from current line when starting a new line.
-- -- o.cursorline = true -- Highlight the screen line of the cursor with CursorLine.
-- -- o.encoding = "UTF-8" -- Sets the character encoding used inside Vim.
-- -- o.ruler = true -- Show the line and column number of the cursor position, separated by a comma.
-- -- o.mouse = "a" -- Enable the use of the mouse. "a" you can use on all modes
-- -- o.title = true -- When on, the title of the window will be o.to the value of 'titlestring'
-- -- o.hidden = true -- When on a buffer becomes hidden when it is |abandon|ed
-- -- o.ttimeoutlen = 0 -- The time in milliseconds that is waited for a key code or mapped key sequence to complete.
-- -- o.wildmenu = true -- When 'wildmenu' is on, command-line completion operates in an enhanced mode.
-- -- o.showcmd = true -- Show (partial) command in the last line of the screen. Set this option off if your terminal is slow.
-- -- o.showmatch = true -- When a bracket is inserted, briefly jump to the matching one.
-- -- o.inccommand = "nosplit" -- When nonempty, shows the effects of :substitute, :smagic, :snomagic and user commands with the :command-preview flag as you type.
-- -- o.splitright = true
-- -- o.splitbelow = true -- When on, splitting a window will put the new window below the current one
-- -- o.termguicolors = true
--
-- -- Colors and styling {{{
-- o.termguicolors = true
-- --}}}
--
-- -- Spaces and Tabs {{{}
-- o.tabstop=2
-- o.softtabstop=2
-- o.shiftwidth=2
-- o.expandtab = true
-- -- }}}
--
-- -- UI Config {{{
-- o.encoding=utf8
-- -- Give us a realtime preview of substitution before we send it
-- o.inccommand=nosplit
-- o.list = true
-- o.lcs = "eol:¬,extends:❯,precedes:❮,tab:>-"
-- o.number = true
-- -- o.relativenumber
-- o.ruler = true
-- o.cursorline = true
-- o.smartindent = true
-- o.autoindent = true
-- o.wrap = true
-- o.linebreak = true
-- o.wildmenu = true
-- o.lazyredraw = true
-- o.showmatch = true
-- -- o.noshowmode = true -- lightline shows the status not vim
-- o.showtabline=2
-- -- o.shortmess+="c"
-- o.updatetime=300
-- o.signcolumn="yes"
--
--
--
-- -- --  Strip all trailing whitespace in file
-- -- function! StripWhitespace ()
-- --     exec ':%s/ \+$//g'
-- -- endfunction
-- -- nnoremap <leader><leader> :call StripWhitespace()<CR>
--
-- -- Display extra whitespace
-- -- o.list listchars=tab:»·,trail:·
--
-- -- -- Use bash internally
-- -- if &shell =~# 'fish$'
-- --   o.shell=/bin/bash
-- -- endif
--
-- -- " Auto open NERDTree on startup if no files are specified
-- -- autocmd vimenter * if !argc() | NERDTree | endif
--
-- -- " Close vim if the only window left open is NERDTree
-- -- autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
--
--
-- -- ================ Persistent Undo ==================
-- -- Keep undo history across sessions, by storing in file.
--
-- -- silent !mkdir -p ~/.vimbackups > /dev/null 2>&1
-- o.undodir = "$HOME/.vimbackups"
-- o.undofile = true
--
--
-- --o.showcmd
-- --}}}
--
-- -- Searching {{{
-- o.incsearch = true
-- o.hlsearch = true
-- o.smartcase = true
-- o.ignorecase = true
-- -- }}}
--
-- -- -- Folding {{{
-- -- o.foldenable
-- -- o.foldlevelstart=10
-- -- o.foldnestmax=10
-- -- -- }}}
--
-- -- o.nobackup = true
-- -- o.nowritebackup = true
-- -- o.noswapfile = true
-- o.hidden = true
-- o.history = 100
-- -- o.path+=**
-- o.splitbelow = true
-- o.splitright = true
--
-- o.diffopt = "vertical"
--
-- o.completeopt = "menu,menuone,preview,noselect,noinsert"
