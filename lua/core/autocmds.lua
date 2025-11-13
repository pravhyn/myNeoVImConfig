-- Set relative numbers only in normal mode
vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
                vim.opt.relativenumber = true
        end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
        callback = function()
                vim.wo.relativenumber = false
        end,
})

-- highlights yank

vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
                vim.highlight.on_yank({
                        higroup = "Visual",
                        timeout = 500,
                })
        end,
})

-- Add the following to your `init.vim`: >vim
--     autocmd TextYankPost * silent! lua vim.hl.on_yank {higroup='Visual', timeout=300}

-- Restarts Neovim
vim.api.nvim_create_user_command("RestartNvim", function()
        local cmd = [[silent !powershell -ExecutionPolicy Bypass -File "C:\scripts\restart-nvim.ps1"]]
        vim.cmd(cmd)
        vim.cmd("qa")
end, {})
