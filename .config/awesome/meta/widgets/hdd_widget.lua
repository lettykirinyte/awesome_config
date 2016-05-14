-- Requires:
-- curl
-- awk
-- telnet
-- hddtemp
-- hddtemp configuired service
local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

hdd_widget = {}

do

    local get_hdd_temp = function()
        local handler = io.popen("echo | curl --connect-timeout 1 -fsm 3 telnet://127.0.0.1:7634 | awk '{print substr($2, 18, 2);}'")
        local result = handler:read("*a")
        handler:close()
        return result
    end

    hdd_widget.hdd_temp_widget = wibox.widget.textbox()

    hdd_widget.update = function()
        local t = get_hdd_temp()
        t = t:gsub('\n', '')
        t = t .. '°C'

        hdd_widget.hdd_temp_widget:set_text(t)
    end


end

local mytimer = timer({ timeout = 1 })
mytimer:connect_signal("timeout", hdd_widget.update)
mytimer:start()

return hdd_widget
