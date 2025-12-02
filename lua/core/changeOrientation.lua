vim.api.nvim_create_user_command("ToggleSplit", function()
        local width = vim.api.nvim_win_get_width(0)
        local height = vim.api.nvim_win_get_height(0)
        if width > height then
                vim.cmd("wincmd K")
        else
                vim.cmd("wincmd H")
        end
end, {})
