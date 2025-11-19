-- Automatically populate quickfix with error diagnostics on notify
local notify = vim.notify

vim.notify = function(msg, level, opts)
        if level == vim.log.levels.ERROR then
                vim.schedule(function()
                        local diagnostics = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR })
                        local qf_list = {}

                        for _, d in ipairs(diagnostics) do
                                table.insert(qf_list, {
                                        bufnr = d.bufnr,
                                        lnum = d.lnum + 1,
                                        col = d.col + 1,
                                        text = d.message,
                                        type = "E",
                                })
                        end

                        if #qf_list > 0 then
                                vim.fn.setqflist({}, " ", {
                                        title = "Diagnostics (Errors)",
                                        items = qf_list,
                                })
                                vim.cmd("copen")
                        end
                end)
        end

        notify(msg, level, opts)
end
