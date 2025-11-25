-- Meant for running whole File
vim.keymap.set("n", "<leader>run", function()
        local file = vim.api.nvim_buf_get_name(0)

        if file == "" then
                require("snacks").notify("No file to run", "warn")
                return
        end

        -- high-precision start time
        local start = vim.uv.hrtime()

        -- Start the python process
        local job
        job = vim.system({ "python", file }, { text = true }, function(res)
                if job._killed then
                        return
                end

                -- calculate duration
                local finish = vim.uv.hrtime()
                local duration = (finish - start) / 1e9 -- convert ns → seconds

                -- choose output (stdout or stderr)
                local output = res.stdout ~= "" and res.stdout or res.stderr

                -- final message with timing included
                local msg = string.format("%s\n\n⏱ Took %.3f seconds", output, duration)

                require("snacks").notify(msg, {
                        title = "Python Output",
                })
        end)

        vim.defer_fn(function()
                if job and job:is_active() then
                        job._killed = true
                        job:kill(15)
                        require("snacks").notify("⛔ Python program killed (took > 10s)", "warn")
                end
        end, 10000)
end, { desc = "Run Python file and notify output" })
