-- UI

return {
    {
        'folke/which-key.nvim',
        config = function()
            require 'which-key'.setup {
                preset = 'modern',
                icons = {
                    separator = "➤ ",
                },
                delay = 400,
            }
        end,
    },
    {
        'winston0410/range-highlight.nvim',
        opts = {},
        dependencies = {
            {
                'winston0410/cmd-parser.nvim',
                opts = {},
            },
        },
    },
    'kyazdani42/nvim-web-devicons',
    {
        'stevearc/dressing.nvim',
        config = function()
            require 'dressing'.setup {
                input = { border = 'single', },
                select = {
                    backend = { 'builtin' },
                    builtin = { border = 'single' },
                },
            }
        end,
    },
    {
        'j-hui/fidget.nvim',
        opts = {
            notification = {
                override_vim_notify = true,
                window = {
                    winblend = 0,
                },
            },
        },
    },
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        config = function()
            require 'telescope'.setup {
                defaults = {
                    prompt_prefix = '❯ ',
                    selection_caret = '⏵ ',
                    borderchars = {
                        prompt = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
                        results = { ' ', ' ', '─', ' ', ' ', ' ', ' ', ' ' },
                        preview = { ' ', ' ', '─', ' ', ' ', ' ', ' ', ' ' },
                    },
                    layout_strategy = 'flex',
                    layout_config = {
                        flex = { flip_columns = 80 },
                        vertical = { width = { padding = 0 }, height = { padding = 0 } },
                        horizontal = { width = { padding = 0 }, height = { padding = 0 } },
                    },
                    mappings = {
                        i = {
                            ['<ESC>'] = 'close',
                            ['<down>'] = 'move_selection_next',
                            ['<M-j>'] = 'move_selection_next',
                            ['<up>'] = 'move_selection_previous',
                            ['<M-k>'] = 'move_selection_previous',
                        },
                    },
                },
            }
        end,
        keys = {
            { '<M-p>',     function() require 'telescope.builtin'.registers() end, desc = 'Paste' },
            { '<leader>o', function() require 'telescope.builtin'.oldfiles() end,  desc = 'Recent files' },
        },
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    {
        'debugloop/telescope-undo.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
        },
        keys = {
            {
                '<M-u>',
                function() require 'telescope'.extensions.undo.undo() end,
                desc = 'undo history',
            },
        },
        opts = {},
        config = function()
            require 'telescope'.setup { extensions = { undo = { mappings = { i = { ['<CR>'] = require 'telescope-undo.actions'.restore } } } } }
            require 'telescope'.load_extension 'undo'
        end,
    },
}
