local wibox = require("wibox")
local vicious = require("vicious")
local awful = require("awful")

local cpu_widget = {}

vicious.cache(vicious.widgets.cpu)

cpu_widget.widget_progress = awful.widget.progressbar()
cpu_widget.widget_progress:set_width(6)
cpu_widget.widget_progress:set_height(10)
cpu_widget.widget_progress:set_vertical(true)
cpu_widget.widget_progress:set_background_color("#494B4F")
cpu_widget.widget_progress:set_border_color(nil)
cpu_widget.widget_progress:set_color(
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

cpu_widget.text = wibox.widget.textbox()
vicious.register(
    cpu_widget.text,
    vicious.widgets.cpu,
    "CPU: $1%"
)

vicious.register(
    cpu_widget.widget_progress,
    vicious.widgets.mem,
    "$1",
    13
)

return cpu_widget
