---------------------
--- Notifications ---
---------------------

local M = {}

function M.setup()
    local notify = require 'notify'
    notify.setup { background_colour = "#00000000", }

    -- set the default notify handler to the notify plugin
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.notify = function(msg, ...)
        -- ignore this message
        if msg:match "warning: multiple different client offset_encodings" then
            return
        end
        notify(msg, ...)
    end

    -- LSP messages as notifications
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        local lvl = ({
                "ERROR",
                "WARN",
                "INFO",
                "DEBUG",
            })[result.type]
        notify(result.message, lvl, {
            title = "LSP | " .. client.name,
            timeout = 120,
            keep = function()
                return lvl == "ERROR" or lvl == "WARN"
            end,
        })
    end
end

return M
