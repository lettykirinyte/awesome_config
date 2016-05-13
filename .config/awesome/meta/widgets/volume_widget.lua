local wibox = require("wibox")
local awful = require("awful")

local volume_widget = {}

do
    volume_widget.channel = "Master"
    volume_widget.step = "5%"
    volume_widget.icon_path = nil

    volume_widget.widget_text = wibox.widget.textbox()
    volume_widget.widget_icon = wibox.widget.imagebox()

    volume_widget.update = function ()
       local fd = io.popen("amixer sget " .. volume_widget.channel)
       local status = fd:read("*all")
       fd:close()

       local volume_level = tonumber(string.match(status, "(%d?%d?%d)%%"));
       local volume = volume_level

       if volume_widget.icon_path ~= nil then
           if string.find(status, "[on]", 1, true) then
               volume_widget.widget_icon:set_image(
                   volume_widget.icon_path .. '/volume_full.png'
               )
               volume_widget.widget_text:set_text(volume .. '%')
           else
               volume_widget.widget_icon:set_image(
                   volume_widget.icon_path .. '/volume_muted.png'
               )
               volume_widget.widget_text:set_text('OFF')
           end
       end

    end

    volume_widget.up = function ()
        local h = io.popen(
            "amixer set "..volume_widget.channel.." "..volume_widget.step.."+"
        )
        h:read("*all")
        h:close()
        volume_widget.update()
    end

    volume_widget.down = function ()
        local h = io.popen(
            "amixer set "..volume_widget.channel.." "..volume_widget.step.."-"
        )
        h:read("*all")
        h:close()
        volume_widget.update()
    end

    volume_widget.toggle = function ()
        io.popen("amixer set "..volume_widget.channel.." toggle"):read("*all")
        volume_widget.update()
    end

    volume_widget.initi = function(icon_path)
        volume_widget.icon_path = icon_path
    end
end

volume_widget.timer = timer({ timeout = 10 })
volume_widget.timer:connect_signal("timeout", function () volume_widget.update() end)
volume_widget.timer:start()

return volume_widget
