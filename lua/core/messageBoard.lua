local Layout = require("nui.layout")
local Popup = require("nui.popup")
local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local function notifications_to_lines()
        local history = require("snacks").notifier.get_history()
        if not history or vim.tbl_isempty(history) then
                vim.notify("No notifications in history", vim.log.levels.WARN)
                return
        end

        local lines = {}

        for i, n in ipairs(history) do
                local title = (n.title and n.title ~= "") and n.title or "Notification"
                local level = n.level or "info"
                local icon = n.icon or ""
                local time = n.added and os.date("%Y-%m-%d %H:%M:%S", math.floor(n.added)) or "unknown"

                table.insert(lines, string.rep("─", 80))
                table.insert(lines, string.format("%d. %s [%s] %s @ %s", i, icon, level:upper(), title, time))

                if n.msg then
                        for _, msg_line in ipairs(vim.split(n.msg, "\n", { plain = true })) do
                                table.insert(lines, "  " .. msg_line)
                        end
                end
        end

        table.insert(lines, string.rep("─", 80))

        if lines == nil then
                lines = { "empty" }
        end
        return lines
end

local function messages_to_buffer()
        -- Use redir to capture the real :messages output
        vim.cmd([[
    redir => g:__nvim_messages
    silent messages
    redir END
  ]])

        local output = vim.g.__nvim_messages
        vim.g.__nvim_messages = nil -- cleanup

        if not output or output == "" then
                return { "No messages found" }
        end

        local lines = {}
        table.insert(lines, "# Neovim :messages")
        table.insert(lines, "")
        table.insert(lines, string.rep("─", 80))

        for _, line in ipairs(vim.split(output, "\n", { plain = true })) do
                table.insert(lines, line)
        end

        table.insert(lines, string.rep("─", 80))

        return lines
end

-- local notification_panel = Popup({
--         border = {
--                 style = "double",
--                 text = {
--                         top = "Notifications List",
--                         top_align = "center",
--                 },
--         },
--         enter = true,
-- })
-- local layout = Layout(
--         {
--                 relative = "editor",
--                 position = "50%",
--                 size = {
--                         height = 30,
--                         width = 190,
--                 },
--         },
--         Layout.Box({
--                 Layout.Box(notification_panel, { size = "100%" }),
--         }, { dir = "row" })
-- )

local notification_panel = Popup({
        border = {
                style = "rounded",
                text = {
                        top = " Notifications ",
                        top_align = "center",
                },
                padding = {
                        top = 1,
                        bottom = 1,
                        left = 2,
                        right = 2,
                },
        },
        win_options = {
                winblend = 5, -- slight transparency
                wrap = true,
                spell = false,
        },
        focusable = true,
        enter = true,
})

-- Right-side half-width layout
local layout = Layout({
        relative = "editor",
        position = {
                row = 0,
                col = math.floor(vim.o.columns / 2), -- ✅ right half
        },
        size = {
                height = vim.o.lines - 2,
                width = math.floor(vim.o.columns / 2), -- ✅ half width
        },
}, Layout.Box(Layout.Box(notification_panel, { size = "100%" }), { dir = "col" }))

layout:mount()

local notifications_lines = notifications_to_lines()

vim.api.nvim_buf_set_lines(notification_panel.bufnr, 0, -1, false, notifications_lines or "empty")
