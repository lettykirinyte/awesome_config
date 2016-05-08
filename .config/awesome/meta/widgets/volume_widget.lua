local wibox = require("wibox")
local awful = require("awful")

local volume_widget = {}

volume_widget.channel = "Master"
volume_widget.step = "5%"

volume_widget.widget_text = wibox.widget.textbox()

volume_widget.widget_progress = awful.widget.progressbar()
volume_widget.widget_progress:set_width(6)
volume_widget.widget_progress:set_height(8)
volume_widget.widget_progress:set_vertical(true)
volume_widget.widget_progress:set_background_color("#494B4F")

volume_widget.update = function ()
   local fd = io.popen("amixer sget " .. volume_widget.channel)
   local status = fd:read("*all")
   fd:close()

   local volume_level = tonumber(string.match(status, "(%d?%d?%d)%%"));
   local volume = volume_level

   if string.find(status, "[on]", 1, true) then
       volume = volume .. "%"

       volume_widget.widget_progress:set_color('#00bfff')
       volume_widget.widget_progress:set_value(volume_level / 100)
   else
       volume = volume .. "M"

       volume_widget.widget_progress:set_color('#ff0000')
       volume_widget.widget_progress:set_value(volume_level / 100)
   end

   volume_widget.widget_text:set_text("Vol: " .. volume)
end

volume_widget.up = function ()
    io.popen("amixer set "..volume_widget.channel.." "..volume_widget.step.."+"):read("*all")
    volume_widget.update()
end

volume_widget.down = function ()
    io.popen("amixer set "..volume_widget.channel.." "..volume_widget.step.."-"):read("*all")
    volume_widget.update()
end

volume_widget.toggle = function ()
    io.popen("amixer set "..volume_widget.channel.." toggle"):read("*all")
    volume_widget.update()
end

volume_widget.update()

volume_widget.timer = timer({ timeout = 10 })
volume_widget.timer:connect_signal("timeout", function () volume_widget.update() end)
volume_widget.timer:start()

return volume_widget
