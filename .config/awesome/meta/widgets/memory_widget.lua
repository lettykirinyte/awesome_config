local awful = require("awful")
local vicious = require("vicious")
local wibox = require("wibox")

local memory_widget = {}
memory_widget.widget_progress = awful.widget.progressbar()
memory_widget.widget_progress:set_width(6)
memory_widget.widget_progress:set_height(10)
memory_widget.widget_progress:set_vertical(true)
memory_widget.widget_progress:set_background_color("#494B4F")
memory_widget.widget_progress:set_border_color(nil)
memory_widget.widget_progress:set_color(
    {
        type = "linear",
        from = { 0, 0 },
        to = { 10,0 },
        stops = {
            {0, "#00BFFF"},
            {0.5, "#00BFFF"},
            {1, "#00BFFF"}
        }
    }
)

memory_widget.widget_text = wibox.widget.textbox()

vicious.register(
    memory_widget.widget_text,
    vicious.widgets.mem,
    "Mem: $1%"
)

vicious.register(
    memory_widget.widget_progress,
    vicious.widgets.mem,
    "$1",
    13
)

return memory_widget
