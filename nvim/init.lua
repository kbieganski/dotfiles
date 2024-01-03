-- General settings
require 'options'.set()
require 'mappings'.set()
require 'autocmds'.setup()

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


-- TODO:
-- Finish setting up zk
-- Set up lazy loading for plugins
-- Set up DAP configs
-- Figure out a good debug flow
-- Fix missing required fields in TS config and CMP config
-- Free keys: Mark keys ` ' m
--            Unused: \
--            Potentially usless: z s S
