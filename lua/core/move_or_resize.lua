local function smart_win_nav_or_resize(dir)
        local win_before = vim.api.nvim_get_current_win()

        -- Try to move
        vim.cmd("wincmd " .. dir)

        local win_after = vim.api.nvim_get_current_win()

        -- If we didn't move, resize instead
        if win_before == win_after then
                if dir == "h" then
                        vim.cmd("vertical resize +5")
                elseif dir == "l" then
                        vim.cmd("vertical resize +5")
                elseif dir == "j" then
                        vim.cmd("resize +3")
                elseif dir == "k" then
                        vim.cmd("resize +3")
                end
        end
end

vim.keymap.set("n", "<C-w>h", function()
        smart_win_nav_or_resize("h")
end)
vim.keymap.set("n", "<C-w>l", function()
        smart_win_nav_or_resize("l")
end)
vim.keymap.set("n", "<C-w>j", function()
        smart_win_nav_or_resize("j")
end)
vim.keymap.set("n", "<C-w>k", function()
        smart_win_nav_or_resize("k")
end)
