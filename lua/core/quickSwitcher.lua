vim.keymap.set("n", "<leader>;", function()
        vim.ui.input({ prompt = "Buffer name: " }, function(input)
                if not input or input == "" then
                        return
                end
                local buffers = vim.fn.getbufinfo({ buflisted = 1 })
                local matches = {}

                for _, buf in ipairs(buffers) do
                        local name = buf.name:match("[^/\\]+$") -- get filename only
                        if name and name:lower():find(input:lower(), 1, true) then
                                table.insert(matches, { buf = buf.bufnr, name = name })
                        end
                end

                if #matches == 1 then
                        vim.api.nvim_set_current_buf(matches[1].buf)
                elseif #matches > 1 then
                        print("Multiple matches:")
                        for _, m in ipairs(matches) do
                                print(m.name)
                        end
                else
                        print("No match found.")
                end
        end)
end, { desc = "Fuzzy buffer switch" })
