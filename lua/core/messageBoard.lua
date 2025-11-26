local Layout = require("nui.layout")
local Popup = require("nui.popup")
local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local notification_panel = Popup({
        border = {
                style = "double",
                text = {
                        top = "Notifications List",
                        top_align = "center",
                },
        },
        enter = true,
})

local message_panel = Popup({
        border = {
                style = "double",
                text = {
                        top = "Notifications List",
                        top_align = "center",
                },
        },
        enter = true,
})
