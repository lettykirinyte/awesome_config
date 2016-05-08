local wibox = require("wibox")
local vicious = require("vicious")

net_widget = {}

-- change this
net_widget.wired_interface = "enp3s0"
net_widget.wifi_interface = "wlp5s0"

net_widget.widget_text = wibox.widget.textbox()
net_widget.widget_text_background = "C2C2A4"
net_widget.widget_text_foregroung = "FFFFFF"

-- todo format
vicious.register(net_widget.widget_text, vicious.widgets.net,
    function(widget, args)
        local interface = ""
        -- todo change
        if args["{wlp5s0 carrier}"] == 1 then
            interface = "wlp5s0"
        elseif args["{enp3s0 carrier}"] == 1 then
            interface = "enp3s0"
        else
            return ""
        end
        return '<span background="#C2C2A4" font="Inconsolata 11"> <span font ="Inconsolata 11" color="#FFFFFF">'..args["{"..interface.." down_kb}"]..'kbps'..'</span></span>'
    end
, 10)
