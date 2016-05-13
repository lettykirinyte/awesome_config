local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

local memory_widget = {}

do
    local get_memory_info = function()
        local handler = io.popen("cat /proc/meminfo | awk '{print $2}'")
        local total = handler:read()
        local free = handler:read()
        handler:close()
        naughty.notify({title="asdf",text=total})

        total = tonumber(total)
        free = tonumber(free)
        local busy = total - free

        return {total = total, busy = busy}
    end

    memory_widget.widget_text = wibox.widget.textbox()

    memory_widget.update = function()
        memory_info = get_memory_info()

        --local total = memory_info["total"]
        --local busy = memory_info["busy"]
        --local result = math.floor(busy / total * 100)

        --memory_widget.widget_text:set_text(
        --    string.format('%d', result) .. '%'
        --)
        local total = memory_info["total"] / (1024 * 1024)
        local busy = memory_info["busy"] / (1024 * 1024)

        memory_widget.widget_text:set_text(
            string.format('%.2fG/%.2fG', busy, total)
        )
    end

end

local mytimer = timer( {timeout = 1} )
mytimer:connect_signal("timeout", memory_widget.update)
--mytimer:start()

return memory_widget
