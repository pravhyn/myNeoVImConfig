local M = {}

local function macro_recording()
        local reg = vim.fn.reg_recording()
        if reg == "" then
                return ""
        end
        return "● REC @" .. reg
end

local function total_buffers()
        local count = 0
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buflisted") then
                        count = count + 1
                end
        end
        return "Bufs: " .. count
end

local function previous_buffer_name()
        local current = vim.api.nvim_get_current_buf()
        local buffers = vim.fn.getbufinfo({ buflisted = 1 })
        local prev_buf = nil

        for i, bufinfo in ipairs(buffers) do
                if bufinfo.bufnr == current then
                        prev_buf = buffers[i - 1] -- get previous in list
                        break
                end
        end

        if prev_buf and prev_buf.name ~= "" then
                local name = vim.fn.fnamemodify(prev_buf.name, ":t") -- filename only
                return "< " .. name
        else
                return ""
        end
end

local function next_buffer_name()
        local current = vim.api.nvim_get_current_buf()
        local buffers = vim.fn.getbufinfo({ buflisted = 1 })
        local next_buf = nil

        for i, bufinfo in ipairs(buffers) do
                if bufinfo.bufnr == current then
                        next_buf = buffers[i + 1] -- get next in list
                        break
                end
        end

        if next_buf and next_buf.name ~= "" then
                local name = vim.fn.fnamemodify(next_buf.name, ":t") -- filename only
                return name .. " >"
        else
                return ""
        end
end

function M.setup()
        local function lsp_status()
                local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
                if #clients == 0 then
                        return "🛑 No LSP"
                end
                local names = {}
                for _, client in ipairs(clients) do
                        table.insert(names, client.name)
                end
                return "🚀 " .. table.concat(names, ", ")
        end

        require("lualine").setup({
                options = {
                        theme = "dracula", -- picks theme from current colorscheme
                        section_separators = { left = "", right = "" },
                        component_separators = { left = "", right = "" },
                        globalstatus = true, -- single statusline for all windows
                },
                sections = {
                        lualine_a = { { "mode", icon = "" } },
                        lualine_b = { "branch", "diff" },
                        lualine_c = {
                                {
                                        "filename",
                                        path = 1, -- relative path
                                        symbols = { modified = "[+]", readonly = "[RO]", unnamed = "[No Name]" },
                                },
                        },
                        lualine_x = {
                                previous_buffer_name,
                                total_buffers,
                                next_buffer_name,
                                "encoding",
                                "fileformat",
                                "filetype",
                        },
                        lualine_y = {
                                {
                                        macro_recording,
                                        color = { fg = "#ff5555", gui = "bold" }, -- Dracula red
                                },
                                "progress",
                                lsp_status,
                        },
                        lualine_z = { { "location", icon = "" } },
                },
                inactive_sections = {
                        lualine_a = {},
                        lualine_b = {},
                        lualine_c = { "filename" },
                        lualine_x = { "location" },
                        lualine_y = {},
                        lualine_z = {},
                },
                extensions = { "quickfix", "nvim-tree", "fugitive", "lazy" },
        })
end

return M
