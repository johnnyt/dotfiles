return {
  -- Color theme
  {
    "embark-theme/vim",
    name = "embark",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme embark]])
    end,
  },

  -- -- File explorer
  -- {
  --   "kelly-lin/ranger.nvim",
  --   config = function()
  --     require("ranger-nvim").setup({ replace_netrw = true })
  --     vim.api.nvim_set_keymap("n", "<leader>\\", "", {
  --       noremap = true,
  --       callback = function()
  --         require("ranger-nvim").open(true)
  --       end,
  --     })
  --   end,
  -- },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup {}

      local api = require("nvim-tree.api")
      vim.keymap.set("n", "<leader>\\", ":NvimTreeToggle<CR>")
      vim.keymap.set("n", "?", api.tree.toggle_help)
      vim.keymap.set("n", "<leader>sf", ":NvimTreeFindFile<CR>")
    end,
  },

  -- Show keymaps
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    version = "*",
    -- config = true
    -- config = function()
    --   local lspconfig = require("lspconfig")
    --   lspconfig.elixirls.setup({
    --     cmd = { "/Users/johnnyt/elixir-ls/language_server.sh" },
    --   })
    -- end,
  },

  -- -- {
  -- --   "neovim/nvim-lspconfig",
  -- --   config = function()
  -- --     local lspconfig = require("lspconfig")
  -- --     local capabilities = require("cmp_nvim_lsp").default_capabilities()
  -- --     lspconfig.elixirls.setup({
  -- --       cmd = { "elixir-ls" },
  -- --       -- set default capabilities for cmp lsp completion source
  -- --       capabilities = capabilities,
  -- --     })
  -- --   end,
  -- -- },

  {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")

      elixir.setup {
        -- nextls = {enable = true},
        elixirls = {
          enable = true,
          settings = elixirls.settings {
            dialyzerEnabled = false,
            enableTestLenses = false,
          },
          -- on_attach = function(client, bufnr)
          --   vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
          --   vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
          --   vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
          -- end,
        },
        projectionist = {
          enable = false
        }
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- Fuzzy finding (files, buffers)
  {
    "nvim-telescope/telescope.nvim",
    --tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- "BurntSushi/ripgrep",
      -- {
      --   "nvim-telescope/telescope-live-grep-args.nvim" ,
      --   -- This will not install any breaking changes.
      --   -- For major updates, this must be adjusted manually.
      --   version = "^1.0.0",
      --   -- keys = {
      --   --   { -- lazy style key map
      --   --     "<leader>/",
      --   --     lga_actions.quote_prompt(),
      --   --     desc = "Live grep",
      --   --   },
      --   --   { -- lazy style key map
      --   --     "<leader>jk",
      --   --     require("telescope-live-grep-args.actions").quote_prompt(),
      --   --     desc = "Live grep",
      --   --   },
      --   -- },
      -- },
      -- {
      --   "nvim-telescope/telescope-fzf-native.nvim",
      --   build = "make"
      -- },
      {
        "debugloop/telescope-undo.nvim",
        -- keys = {
        --   { -- lazy style key map
        --     "<leader>u",
        --     "<cmd>Telescope undo<cr>",
        --     desc = "undo history",
        --   },
        -- },
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      -- local lga_actions = require("telescope-live-grep-args.actions")

      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = actions.close,
            },
          },
          layout_config = {
            width = 0.8,
            horizontal = {
              preview_width = 0.6
            }
          }
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = {
              "rg",
              "--files",
              "--hidden",
              "--glob=!**/.git/*",
              "--glob=!**/deps/*",
              "--glob=!**/build/*",
            }
          },
          buffers = {
            ignore_current_buffer = true,
            sort_lastused = true,
          },
        },
        -- extensions = {
        --   live_grep_args = {
        --     auto_quoting = true, -- enable/disable auto-quoting
        --     -- define mappings, e.g.
        --     -- mappings = { -- extend mappings
        --     --   i = {
        --     --     ["<C-k>"] = lga_actions.quote_prompt(),
        --     --     ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        --     --     -- freeze the current list and start a fuzzy search in the frozen list
        --     --     ["<C-space>"] = actions.to_fuzzy_refine,
        --     --   },
        --     -- },
        --     -- ... also accepts theme settings, for example:
        --     -- theme = "dropdown", -- use dropdown theme
        --     -- theme = { }, -- use own theme spec
        --     -- layout_config = { mirror=true }, -- mirror preview pane
        --   }
        -- },
        -- keys = {
        --   { -- lazy style key map
        --     "<leader>/",
        --     lga_actions.quote_prompt(),
        --     desc = "Live grep",
        --   },
        --   { -- lazy style key map
        --     "<leader>jk",
        --     lga_actions.quote_prompt(),
        --     desc = "Live grep",
        --   },
        -- },
      })

      -- telescope.load_extension("fzf")
      -- telescope.load_extension("live_grep_args")
      telescope.load_extension("undo")
    end
  },

  -- Syntax highlighting (Treesitter)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function ()
      local parsers = {
        "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "ruby",
        "bash", "fish", "dockerfile", "yaml", "markdown", "markdown_inline",
      }
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = parsers,
        callback = function()
          vim.treesitter.start()
          pcall(function()
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end)
        end,
      })
    end
  },


  -- Git
  {"tpope/vim-fugitive"},
  {"tpope/vim-rhubarb"},      -- GBlame functionality for GitLab and GitHub
  {"airblade/vim-gitgutter", version="*"}, -- Show git status of each line in the left gutter
  -- {"shumphrey/fugitive-gitlab.vim"},


  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = true,
    -- config = function()
    --   require("lualine").setup()
    -- end
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = true,
  },



  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    -- load cmp on InsertEnter
    event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "nvim-tree/nvim-web-devicons",
      "onsails/lspkind.nvim",
    },
    config = function()
      cmp = require("cmp")

      cmp.setup({
        -- Completion settings
        completion = {
          --completeopt = "menu,menuone,noselect"
          keyword_length = 2
        },

        -- Key mapping
        mapping = {
          ["<DOWN>"] = cmp.mapping.select_next_item(),
          ["<UP>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<TAB>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          -- ["<CR>"] = cmp.mapping.confirm {
          --   behavior = cmp.ConfirmBehavior.Replace,
          --   select = true,
          -- },
          ["<CR>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          }),
        },

        -- Load sources, see: https://github.com/topics/nvim-cmp
        sources = {
          { name = "nvim_lsp" },
          -- { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        },

        formatting = {
          format = function(entry, vim_item)
            if vim.tbl_contains({ "path" }, entry.source.name) then
              local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
              if icon then
                vim_item.kind = icon
                vim_item.kind_hl_group = hl_group
                return vim_item
              end
            end
            return require("lspkind").cmp_format({ mode = 'symbol_text' })(entry, vim_item)
          end
        },
      })
    end
  },

  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true,
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    -- event = "VeryLazy",
    -- config = function()
    --   require("nvim-surround").setup({
    --     -- Configuration here, or leave empty to use defaults
    --   })
    -- end
  },

  {
    "windwp/nvim-autopairs",
    -- event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },

  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },

  -- -- Languages
  -- {"elixir-editors/vim-elixir"},
  -- {"jparise/vim-graphql"},
  -- {"pangloss/vim-javascript"},

  -- -- Undo

  -- -- Generate links to code
  -- {
  --   "ruifm/gitlinker.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   config = true -- same as setup({})
  -- },

  -- {"tveskag/nvim-blame-line"},
}
