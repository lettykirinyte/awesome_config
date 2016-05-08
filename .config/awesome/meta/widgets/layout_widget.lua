local wibox = require("wibox")
local awful = require("awful")

local layout_widget = {}

layout_widget.cmd = "setxkbmap"
layout_widget.layout = { { "us", "" , "US" }, { "ru", "" , "RU" } } 
layout_widget.current = 1
layout_widget.count = 3
layout_widget.widget = wibox.widget.textbox()
layout_widget.widget:set_text(
    " " .. layout_widget.layout[layout_widget.current][3] .. " "
)


layout_widget.switch = function ()
    if layout_widget.current == 2 then
        layout_widget.current = 1
    else
        layout_widget.current = 2
    end

    local t = layout_widget.layout[layout_widget.current]
    layout_widget.widget:set_text(
        layout_widget.layout[layout_widget.current][3]
    )
    os.execute( layout_widget.cmd .. " " .. t[1] .. " " .. t[2] )
end

layout_widget.widget:buttons(
    awful.util.table.join(
        awful.button(
            { },
            1,
            function()
                layout_widget.switch()
            end
        )
    )
)

return layout_widget
