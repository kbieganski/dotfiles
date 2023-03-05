-----------------------
--- Syntax awareness ---
------------------------

local M = {}

function M.setup()
    require 'nvim-treesitter.configs'.setup {
        ensure_installed = {
            "bash",
            "c",
            "cpp",
            "css",
            "glsl",
            "go",
            "haskell",
            "html",
            "javascript",
            "lua",
            "python",
            "regex",
            "rust",
            "typescript",
            "zig",
        },
        highlight = { enable = true },
    }
end

return M
