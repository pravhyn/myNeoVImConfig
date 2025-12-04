return {
        {
                "echasnovski/mini.move",
                config = function()
                        require("mini.move").setup()
                end,
        },

        { "nvim-mini/mini.pairs", version = false },
        { "nvim-mini/mini.comment", version = false },
        {
                "nvim-mini/mini.surround",
                version = false,
                config = function()
                        require("mini.surround").setup({
                                mappings = {
                                        add = "ys", -- Add surrounding
                                        delete = "ds", -- Delete surrounding
                                        find = "<leader>sf", -- Find surrounding (right)
                                        find_left = "<leader>sF", -- Find surrounding (left)
                                        highlight = "<leader>sh", -- Highlight surrounding
                                        replace = "cs", -- Replace surrounding

                                        suffix_last = "l", -- Suffix for "prev" method
                                        suffix_next = "n", -- Suffix for "next" method
                                },
                        })
                end,
        },
        {
                "nvim-mini/mini.operators",
                config = function()
                        require("mini.operators").setup({})
                end,
        },
        { "nvim-mini/mini.splitjoin", version = false },
        { "nvim-mini/mini.align", version = false },
        {
                "nvim-mini/mini.test",
                version = false,
                config = function()
                        require("mini.test").setup({

                                collect = {
                                        -- Temporarily emulate functions from 'busted' testing framework
                                        -- (`describe`, `it`, `before_each`, `after_each`, and more)
                                        emulate_busted = true,

                                        -- Function returning array of file paths to be collected.
                                        -- Default: all Lua files in 'tests' directory starting with 'test_'.
                                        find_files = function()
                                                return vim.fn.globpath("tests", "**/test_*.lua", true, true)
                                        end,

                                        -- Predicate function indicating if test case should be executed
                                        filter_cases = function(case)
                                                return true
                                        end,
                                },

                                -- Options for execution of test cases. See `:h MiniTest.execute()`.
                                execute = {
                                        -- Table with callable fields `start()`, `update()`, and `finish()`
                                        reporter = nil,

                                        -- Whether to stop execution after first error
                                        stop_on_error = false,
                                },

                                -- Path (relative to current directory) to script which handles project
                                -- specific test running
                                script_path = "scripts/minitest.lua",

                                -- Whether to disable showing non-error feedback
                                silent = false,
                        })
                end,
        },
}
