Buf = Buf or {}

-- buffer name only (no path, no extension)
function Buf.name(buf)
        buf = buf or 0
        local full = vim.api.nvim_buf_get_name(buf)
        if full == "" then
                return ""
        end
        return vim.fn.fnamemodify(full, ":t:r")
end

-- buffer filetype
function Buf.ft(buf)
        buf = buf or 0
        return vim.bo[buf].filetype or ""
end
function Buf.filename(buf)
        buf = buf or 0
        local full = vim.api.nvim_buf_get_name(buf)
        return full ~= "" and vim.fn.fnamemodify(full, ":t") or ""
end
