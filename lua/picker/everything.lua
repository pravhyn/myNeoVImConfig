-- local snacks = require("snacks")

-- everything picker using the snacks proc source

local function everything_picker()
        local proc = require("snacks.picker.source.proc")
        local preview = require("snacks.picker.preview")

        Snacks.picker.pick({
                title = "Everything",

                finder = function(picker)
                        -- IMPORTANT: never call es with empty query (RAM killer)
                        if not picker.query or picker.query == "" then
                                return
                        end

                        return proc.proc(
                                picker:opts({
                                        cmd = "es", -- or "es.exe" on Windows
                                        args = { "{q}" },

                                        ---@param item snacks.picker.finder.Item
                                        transform = function(item)
                                                item.file = item.text
                                                item.dir = vim.fn.isdirectory(item.file) == 1
                                                item.ordinal = item.text
                                        end,
                                }),
                                picker
                        )
                end,

                preview = function(item, ctx)
                        if not item or not item.file then
                                return
                        end
                        if vim.fn.filereadable(item.file) == 1 then
                                preview.file(item.file, ctx)
                        end
                end,

                confirm = function(picker, item)
                        picker:close()

                        if item.dir then
                                vim.cmd.cd(item.file)
                                vim.notify("cd -> " .. item.file)
                        else
                                vim.cmd.edit(item.file)
                        end
                end,
        })
end

-- vim.keymap.set("n", "<leader>se", everything_picker, { desc = "Snacks: Everything" })
-- keymap to run it
-- vim.keymap.set("n", "<leader>se", everything_picker, { desc = "Snacks: Everything" })
-- vim.keymap.set("n", "<leader>sf", my_finder_picker)
-- vim.keymap.set("n", "<leader>sp", my_simple_picker, { desc = "Snacks: Simple Picker" })
-- vim.keymap.set("n", "<leader>se", everything_picker(), { desc = "Everything Picker" })
everything_picker()
