-- requires:
-- sysstat (mpstat)
-- lm-sensors (sensors)
local wibox = require("wibox")
local awful = require("awful")

cpu_widget = {}

do
    local get_proc_temp = function()
        local handler = io.popen("sensors | awk 'NR==7{print $4;}'")
        local result = handler:read("*a")
        handler:close()
        return result
    end

    local get_proc_idle = function()
        local handler = io.popen("mpstat | awk 'NR==4{print $4;}'")
        local result = handler:read("*a")
        handler:close()
        return result
    end

    cpu_widget.cpu_temp_widget = wibox.widget.textbox()
    cpu_widget.cpu_idle_widget = wibox.widget.textbox()

    cpu_widget.update = function()
        local temp = get_proc_temp()
        local idle = get_proc_idle()
        idle = idle:gsub('\n', '')

        cpu_widget.cpu_temp_widget:set_text(temp)
        cpu_widget.cpu_idle_widget:set_text(idle)
    end
end

local mytimer = timer({ timeout = 1 })
mytimer:connect_signal("timeout", cpu_widget.update)
mytimer:start()

return cpu_widget

