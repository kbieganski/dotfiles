-- Tree-sitter plugins
return {
    {
        'nvim-treesitter/nvim-treesitter',
        opts = {
            ensure_installed = {
                'bash',
                'c',
                'cpp',
                'css',
                'glsl',
                'go',
                'haskell',
                'html',
                'javascript',
                'lua',
                'python',
                'regex',
                'rust',
                'typescript',
                'zig',
            },
            highlight = { enable = true },
        },
        build = ':TSUpdate',
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = { 'nvim-treesitter/nvim-treesitter' }
    },
}
