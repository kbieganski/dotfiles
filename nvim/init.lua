-- General settings
require 'options'.set()
require 'mappings'.set()
require 'autocmds'.setup()
require 'colorscheme'.setup()

vim.filetype.add {
    extension = {
        templ = 'templ'
    },
}

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
    }
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require 'lazy'.setup 'plugins'

require 'diagline_popup'.setup()

function R(name)
    require 'plenary.reload'.reload_module(name)
    return require(name)
end
