local function unwrap_lua_loop()
        local ts_utils = require("nvim-treesitter.ts_utils")
        local node = ts_utils.get_node_at_cursor()
        if not node then
                return
        end

        -- Walk up until we find a loop node
        while node do
                local t = node:type()
                if t == "for_statement" or t == "while_statement" then
                        break
                end
                node = node:parent()
        end

        if not node then
                vim.notify("Cursor is not inside a loop", vim.log.levels.WARN)
                return
        end

        local start_row, _, end_row, _ = node:range()
        local buf = vim.api.nvim_get_current_buf()
        local lines = vim.api.nvim_buf_get_lines(buf, start_row, end_row + 1, false)

        if #lines < 3 then
                return
        end

        -- Remove: first line (for/while) and last line (end)
        table.remove(lines, 1)
        table.remove(lines)

        -- Get indentation of original loop
        local base_indent = lines[1]:match("^%s*") or ""

        -- De-indent inner lines once
        for i, l in ipairs(lines) do
                lines[i] = l:gsub("^" .. base_indent, "")
        end

        -- Replace the whole loop with the inner body
        vim.api.nvim_buf_set_lines(buf, start_row, end_row + 1, false, lines)
end

vim.keymap.set("n", "<leader>ul", unwrap_lua_loop, {
        desc = "Unwrap loop (delete loop, keep body)",
})
