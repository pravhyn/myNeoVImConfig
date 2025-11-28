-- ~/.config/nvim/lua/core/keymaps.lua
-- tim
-- to luafile the current file
vim.keymap.set("n", "<leader>ls", function()
        vim.cmd("luafile " .. vim.fn.expand("%"))
        vim.notify("loaded")
end, { desc = "Source current Lua file" })

-- live liveserver
vim.keymap.set("n", "<leader>lss", ":!live-server .<CR>", { desc = "Start live-server" })

-- LSP
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })

-- Noetest keymaps
local neotest = require("neotest")

vim.keymap.set("n", "<leader>tn", function()
        neotest.run.run() -- run nearest test
end)

vim.keymap.set("n", "<leader>tf", function()
        neotest.run.run(vim.fn.expand("%")) -- run current file
end)

vim.keymap.set("n", "<leader>ts", function()
        neotest.summary.toggle() -- toggle summary panel
end)

vim.keymap.set("n", "<leader>to", function()
        neotest.output.open({ enter = true }) -- open test output
end)

vim.keymap.set("n", "<leader>tl", function()
        neotest.run.run_last() -- rerun last test
end)
-- To delete buffers
-- Safe close current buffer
vim.keymap.set("n", "<leader>qq", function()
        require("snacks").bufdelete()
end)
-- toggleTerm
-- ToggleTerm Send-to-Terminal Keymaps
local trim_spaces = true
local toggleterm = require("toggleterm")

vim.keymap.set("n", "<leader>cd", function()
        local buf_path = vim.api.nvim_buf_get_name(0)
        if buf_path == "" then
                vim.notify("No file path detected", vim.log.levels.WARN)
                return
        end

        local dir = vim.fn.fnamemodify(buf_path, ":p:h")
        local cmd = "cd " .. vim.fn.shellescape(dir)

        -- Send only the cd command to terminal
        require("toggleterm").send_lines_to_terminal("single_line", true, {
                lines = { cmd },
        })

        -- Notify inside Neovim only (not sent to terminal)
        vim.notify("Sent to terminal: " .. cmd, vim.log.levels.INFO)
end, { desc = "Send buffer directory as cd to terminal" })

vim.keymap.set("n", "<leader>tp", function()
        local clipboard = vim.fn.getreg("+")
        if clipboard and clipboard ~= "" then
                require("toggleterm").send_lines_to_terminal("single_line", true, {
                        lines = { clipboard },
                        args = vim.v.count,
                })
        else
                vim.notify("Clipboard is empty", vim.log.levels.WARN)
        end
end, { desc = "Send clipboard text to terminal" })
-- Visual mode: Send selected lines (choose mode: "single_line", "visual_lines", or "visual_selection")
vim.keymap.set("v", "<space>s", function()
        toggleterm.send_lines_to_terminal("visual_selection", trim_spaces, { args = vim.v.count })
end, { desc = "Send visual selection to terminal" })

-- Operator-pending: Send motion to terminal
vim.keymap.set("n", "<leader><c-\\>", function()
        set_opfunc(function(motion_type)
                toggleterm.send_lines_to_terminal(motion_type, trim_spaces, { args = vim.v.count })
        end)
        vim.api.nvim_feedkeys("g@", "n", false)
end, { desc = "Send motion to terminal" })

-- Normal mode: Send current line to terminal
vim.keymap.set("n", "<leader><c-\\><c-\\>", function()
        set_opfunc(function(motion_type)
                toggleterm.send_lines_to_terminal(motion_type, trim_spaces, { args = vim.v.count })
        end)
        vim.api.nvim_feedkeys("g@_", "n", false)
end, { desc = "Send current line to terminal" })

-- Normal mode: Send entire file to terminal
vim.keymap.set("n", "<leader><leader><c-\\>", function()
        set_opfunc(function(motion_type)
                toggleterm.send_lines_to_terminal(motion_type, trim_spaces, { args = vim.v.count })
        end)
        vim.api.nvim_feedkeys("ggg@G''", "n", false)
end, { desc = "Send entire file to terminal" })

-- command line testing
-- Lua (init.lua)
-- lua print(vim.inspect(require("before")))
vim.keymap.set("v", "<leader>xr", function()
        local cmd = table.concat(vim.fn.getline("'<", "'>"), "\n")
        vim.cmd(cmd)
end, { desc = "Execute selected text as command" })

-- Lua
-- vim.keymap.set("n", "x", require("substitute").operator, { noremap = true }) -- like yi{ then xi{
-- vim.keymap.set("n", "xl", require("substitute").line, { noremap = true }) -- after yanking line, then xl
-- vim.keymap.set("n", "X", require("substitute").eol, { noremap = true }) -- pastes then removes other stuff till eol
-- vim.keymap.set("x", "x", require("substitute").visual, { noremap = true }) -- removes the selection, pastes the yank
--
-- vim.keymap.set("n", "<leader>x", require("substitute.exchange").operator, { noremap = true })
-- vim.keymap.set("x", "<leader>x", require("substitute.exchange").visual, { noremap = true })
-- vim.keymap.set("n", "<leader>X", require("substitute.exchange").line, { noremap = true })
