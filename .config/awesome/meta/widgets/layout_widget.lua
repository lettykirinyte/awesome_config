local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

local layout_widget = {
    current_layout = 1,
    layouts = nil,
    cmd = "setxkbmap"
}

layout_widget.widget = wibox.widget.textbox()

layout_widget.update_widget = function()
    local l = layout_widget.layouts[layout_widget.current_layout]
    layout_widget.widget:set_text(l.visible)
end

layout_widget.switch = function ()
    if layout_widget.layouts ~= nil then
        local len = 2
        if len > 1 then
            layout_widget.current_layout = layout_widget.current_layout + 1

            if layout_widget.current_layout > len then
                layout_widget.current_layout = 1
            end

            local l = layout_widget.layouts[layout_widget.current_layout]
            local command = 
                layout_widget.cmd .. " " .. l.name .. " " .. l.args
            print(command)

            os.execute(command)
            layout_widget:update_widget()
        end
    end
end

layout_widget.initi = function(blyat_mooduck_ti_a_ne_peremenna9)
    layout_widget.layouts = blyat_mooduck_ti_a_ne_peremenna9
    print(blyat_mooduck)
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
