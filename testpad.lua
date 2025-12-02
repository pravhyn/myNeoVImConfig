-- Access the notifications history table
local history = require("snacks").notifications.history()

-- Example: print them out
for _, item in ipairs(history) do
        print(item.level, item.msg)
end
