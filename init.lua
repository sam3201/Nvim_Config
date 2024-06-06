local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

local packer = require('packer').startup(function(use)
    -- Add plugins
    use 
    {
    'wbthomason/packer.nvim'
    }

    use {
        'nvim-lua/plenary.nvim'
    } --Dependency required by telescope
    use {
        'nvim-telescope/telescope.nvim'
    }
    use {
        'nvim-lua/completion-nvim'
    }
    use {
        'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'
    }
    use {
        "rose-pine/neovim", as = "rose-pine"
    }
    use {
        'Shadorain/shadotheme'
    }
    use {
        'hrsh7th/nvim-cmp'
    }
    use {
        'hrsh7th/cmp-buffer'
    }
    use {
        'hrsh7th/cmp-path'
    }
    use {
        'onsails/lspkind-nvim'
    } --lspkind for symbols	in completion menu
    use {
        'williamboman/mason.nvim'
    }
    use {
        'williamboman/mason-lspconfig.nvim'
    }
    use {
        'L3MON4D3/LuaSnip'
    }
    use {
        'neoclide/coc.nvim', branch = 'release'
    }
    use {
        'folke/tokyonight.nvim'
    }
    use {
        'neovim/nvim-lspconfig'
    }
    use {
        "Exafunction/codeium.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function()
            require("cmp").setup {
                sources = {
                    {
                        name = "codeium"
                    }
                }
            }
        end
    }
  use {'xiyaowong/transparent.nvim'}
  use { 'ellisonleao/gruvbox.nvim' }
  use {'tjdevries/colorbuddy.nvim'}
  use {'codota/tabnine-nvim', run = "./dl_binaries.sh" }
  use {'sourcegraph/sg.nvim'}
  use {"lukas-reineke/lsp-format.nvim"}
  use {'m4xshen/autoclose.nvim'}
  use {
    'ray-x/lsp_signature.nvim',
    config = function()
        require'lsp_signature'.setup()
    end }
 
end)

-- Configure and set up telescope.nvim
require('telescope').setup()
local lspconfig = require('lspconfig')
require 'lspconfig'.pyright.setup {}

--Set up Language Servers
lspconfig.clangd.setup {}
lspconfig.jedi_language_server.setup {}

--Set tab width to 2 spaces
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

-- Enable line numbers
vim.wo.number = true

-- Highlight search results
vim.o.hlsearch = true

-- Set color theme
require("rose-pine").setup({
    variant = "auto",      --auto, main, moon, or dawn
    dark_variant = "main", --main, moon, or dawn
    dim_inactive_windows = true,
    extend_background_behind_borders = true,

    enable = {
        terminal = true,
        legacy_highlights = true, --Improve compatibility for previous versions of Neovim
        migrations = true,        --Handle deprecated options automatically
    },

    styles = {
        bold = true,
        italic = true,
        transparency = true,
    },

    groups = {
        border = "muted",
        link = "iris",
        panel = "surface",

        error = "love",
        hint = "iris",
        info = "foam",
        note = "pine",
        todo = "rose",
        warn = "gold",

        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",

        h1 = "iris",
        h2 = "foam",
        h3 = "rose",
        h4 = "gold",
        h5 = "pine",
        h6 = "foam",
    },

    highlight_groups = {
        --Comment = {fg = "foam"},
        --VertSplit = {fg = "muted", bg = "muted"},
    },

    before_highlight = function(group, highlight, palette)
        --Disable all undercurls
        -- if highlight.undercurl then
        -- highlight.undercurl = false
        -- end
        --
        -- Change palette colour
        -- if highlight.fg == palette.pine then
        -- highlight.fg = palette.foam
        -- end
    end,
})
--Set color theme
require('tokyonight').setup {}

vim.cmd("colorscheme rose-pine-moon")
vim.cmd("colorscheme shado")
vim.cmd("colorscheme tokyonight-moon")

--[[
-- Load coc.nvim settings
vim.cmd('source $HOME/.config/nvim/plugin/config/coc.vim')
--
--]]
-- Define custom key mappings
vim.api.nvim_set_keymap('n', '<C-l>', ':nohlsearch<CR>', { noremap = true, silent = true })
-- Set up tree - sitter
require('nvim-treesitter.configs').setup {
    ensure_installed = "all", --Install all available parsers
    highlight = {
    enable = true         -- Enable tree - sitter syntax highlighting
    },
    indent = {
    enable = true -- Enable tree - sitter indentation
    }
}

require('tabnine').setup({
  disable_auto_comment=false,
  accept_keymap="<Tab>",
  dismiss_keymap = "<C-]>",
  debounce_ms = 800,
  suggestion_color = {gui = "#808080", cterm = 244},
  exclude_filetypes = {"TelescopePrompt", "NvimTree"},
  log_file_path = nil, -- absolute path to Tabnine log file
})

local mason = require('mason').setup()
local mason_lsp = require('mason-lspconfig').setup()

require('codeium').setup({
    --best mode for autogeneration of code
    mode = "enterprise_mode",

})

local sg = require('sg').setup({

})
-- Set up nvim - cmp

local cmp = require('cmp')
cmp.setup({
    sources = {
        { name = 'codeium' }, -- Codeium as the primary source
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        { name = 'nvim_lua' },
    },
    mapping = {
        ['<}>'] = cmp.mapping.select_next_item(),
        ['<}>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    formatting = {
        format = require('lspkind').cmp_format({
            mode = 'enterprise_mode',
            maxwidth = 50,
            ellipsis_char = '...',
            symbol_map = {
                Codeium = "" -- Assuming '' is the symbol you want
            }
        })
    }
})


require("transparent").setup({
    alpha = 100, -- Set transparency to 75%
    exclude_groups = {}, -- Exclude any specific groups if needed
})

require("lsp-format").setup {}

local on_attach = function(client, bufnr)
    require("lsp-format").on_attach(client, bufnr)
end

require("autoclose").setup()

vim.g.SupertabDefaultCompletionType = '<Tab>'


