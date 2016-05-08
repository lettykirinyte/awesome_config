local wibox = require("wibox")
local awful = require("awful")

redshift_widget = {}
redshift_widget.attached = false
redshift_widget.active = false
redshift_widget.running = false

icon_off = "/home/mezzari/.config/awesome/meta/icons/redshift/redshift_off.png"
icon_on = "/home/mezzari/.config/awesome/meta/icons/redshift/redshift_on.png"

redshift_widget.widget = wibox.widget.imagebox()
redshift_widget.ini = function()
    os.execute("pkill redshift")

    awful.util.spawn_with_shell("redshift -x")
    awful.util.spawn_with_shell("redshift")

    redshift_widget.running = true
    redshift_widget.active = true
end

redshift_widget.toggle = function()
    if redshift_widget.running then
        os.execute("pkill -USR1 redshift")
        redshift_widget.active = not redshift_widget.active
        redshift_widget.running = not redshift_widget.running
    else
        redshift_widget:ini()
    end

    redshift_widget:update()
end

redshift_widget.off = function ()
    if redshift_widget.running and redshift_widget.active then
        redshift_widget:toggle()
    end
end

redshift_widget.on = function ()
    if not redshift_widget.active then
        redshift_widget:toggle()
    end
end

redshift_widget.is_active = function()
    return redshift_widget.active
end

redshift_widget.update = function()
     if redshift_widget.running and redshift_widget.active then
         redshift_widget.widget:set_image(icon_on)
     else
         redshift_widget.widget:set_image(icon_off)
     end
end

redshift_widget:ini()
redshift_widget:toggle()
