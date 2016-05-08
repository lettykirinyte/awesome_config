local naughty = require("naughty")
local beautiful = require("beautiful")
local wibox = require("wibox")
local awful = require("awful")

local function directory_exists(path)
    if type(path) ~= "string" then
        return false
    end

    local response = os.execute("cd " .. path)
    return response == 0
end

local function file_exists(path)
    if type(path) ~= "string" then
        return false
    end

    local f = io.open(path, "r")

    if f~=nil then
        io.close(f)
        return true
    end

    return false
end

local battery_widget = {}
battery_widget.adapter = "BAT1"
battery_widget.charging = ""
battery_widget.state = 100
battery_widget.widget_text = wibox.widget.textbox()
battery_widget.has_battery = file_exists("/sys/class/power_supply/"..battery_widget.adapter)

battery_widget.widget_progress = awful.widget.progressbar()
battery_widget.widget_progress:set_width(6)
battery_widget.widget_progress:set_height(8)
battery_widget.widget_progress:set_vertical(true)
battery_widget.widget_progress:set_background_color("#494B4F")
battery_widget.widget_progress:set_color('#00bfff')

battery_widget.get_battery_state = function (adapter)
    local fcur = io.open("/sys/class/power_supply/"..adapter.."/charge_now")
    local fcap = io.open("/sys/class/power_supply/"..adapter.."/charge_full")
    local fsta = io.open("/sys/class/power_supply/"..adapter.."/status")
    local cur = fcur:read()
    local cap = fcap:read()
    local sta = fsta:read()
    fcur:close()
    fcap:close()
    fsta:close()

    local battery = math.floor(cur * 100 / cap)
    if sta:match("Charging") then
        dir = 1
    elseif sta:match("Discharging") then
        dir = -1
    else
        dir = 0
    end

    return battery, dir
end

battery_widget.update = function()
    --if directory_exists("/sys/class/power_supply/"..battery_widget.adapter) then
    if battery_widget.has_battery then
        st, charging = battery_widget.get_battery_state(battery_widget.adapter)

        if battery_widget.state ~= st then
            if battery_widget.should_notify(st) then
                battery_widget.state = st
                battery_widget.notify()
            end
        end

        battery_widget.state = st

        if charging == 1 then
            battery_widget.charging = "Charging"
        elseif charging == -1 then
            battery_widget.charging = "Discharging"
        else
            battery_widget.charging = ""
        end

        battery_widget.widget_text:set_text("Bat: " .. battery_widget.state)

        battery_widget.widget_progress:set_value(battery_widget.state / 100)
    else
        battery_widget.charging = "No battery"
        battery_widget.widget_text:set_text("⚡⚡")
        battery_widget.widget_progress:set_value(1)
    end
end

battery_widget.notify = function()
    naughty.notify({
        title = "⚡ Warning! ⚡",
        text = "Battery charge is low ( ⚡"..battery_widget.state.."%)!",
        timeout = 7,
        position = "top_right",
        fg = beautiful.fg_focus,
        bg = beautiful.bg_focus
    })
end

battery_widget.should_notify = function (current_state)
    if current_state < 10 then
        return true
    elseif current_state < 18 then
        return (current_state % 3) == 0
    elseif current_state < 25 then
        return (current_state % 5) == 0
    else
        return false
    end
end

if battery_widget.has_battery then
    battery_widget.update()

    battery_widget.timer = timer({ timeout = 30})
    battery_widget.timer:connect_signal(
        "timeout",
        function ()
            battery_widget.update()
        end
    )
    battery_widget.timer:start()
end

return battery_widget
