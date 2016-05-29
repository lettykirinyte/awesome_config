-- requires:
-- sysstat (mpstat)
-- lm-sensors (sensors)
local wibox = require("wibox")
local awful = require("awful")

nvidia_widget = {}

do
    local get_nvidia_temp = function()
        local handler = io.popen("sensors | awk 'NR==7{print $2;}'")
        local result = handler:read("*a")
        handler:close()
        return result
    end

    nvidia_widget.nvidia_widget_text = wibox.widget.textbox()

    nvidia_widget.update = function()
        temp = get_nvidia_temp()
        nvidia_widget.nvidia_widget_text:set_text(temp)
    end
end

local mytimer = timer({ timeout = 1 })
mytimer:connect_signal("timeout", nvidia_widget.update)
mytimer:start()

return nvidia_widget

