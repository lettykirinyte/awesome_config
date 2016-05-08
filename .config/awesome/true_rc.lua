local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")
local json = require("json")

require("/meta/widgets/redshift_widget")

layout_widget = require("/meta/widgets/layout_widget")
volume_widget = require("/meta/widgets/volume_widget")
battery_widget = require("/meta/widgets/battery_widget")
memory_widget = require("/meta/widgets/memory_widget")
cpu_widget = require("/meta/widgets/cpu_widget")

-- {{{ Configuration
configuration = {}

configuration.constant = {
    key = {
        mod = "Mod4",
        alt = "Mod1",
        shift = "Shift",
        ctrl = "Control",
        volume_up = "XF86AudioRaiseVolume",
        volume_down = "XF86AudioLowerVolume",
        volume_mute = "XF86AudioMute",
        brightness_up = "XF86MonBrightnessUp",
        brightness_down = "XF86MonBrightnessDown",
        tab = "Tab",
        enter = "Return",
        num_1 = "#87",
        num_2 = "#88",
        num_3 = "#89",
        num_4 = "#83",
        num_5 = "#84",
        num_6 = "#85",
        num_7 = "#79",
        num_8 = "#80",
        num_9 = "#81",
        num_0 = "#90",
        space = "space",
        delete = "Delete",
        left_shift = "Shift_L",
        up = "Up",
        left = "Left",
        down = "Down",
        right = "Right"
    }
}

-- Contains created menus
configuration.menu = {}

-- Contains paths to some things
configuration.paths = {}
configuration.paths.home = "/home/mezzari"
configuration.paths.conf = configuration.paths.home .. "/.config/awesome"
configuration.paths.theme = configuration.paths.conf .. "/themes/powerarrowf/theme.lua"
configuration.paths.wallpaper = configuration.paths.conf .. "/meta/wallpapers/senia.jpg"
configuration.paths.idea = "/home/data/Programs/idea/bin/idea.sh"
configuration.paths.config_dir = configuration.paths.conf .. "/meta/configs"
configuration.paths.config_screens = configuration.paths.config_dir .. "/screens.json"
configuration.paths.config_wallpapers = configuration.paths.config_dir .. "/wallpapers.json"

-- Contains programs
configuration.program = {}
configuration.program.browser = "chromium --user-data-dir=/home/data/tmp/chromium"
configuration.program.browser_1 = "chromium --user-data-dir=/home/data/tmp/chromium"
configuration.program.browser_2 = "chromium --user-data-dir=/home/data/tmp/chromium_2"
configuration.program.browser_3 = "chromium --user-data-dir=/home/data/tmp/chromium_3"
configuration.program.keymanager = "keepassx"
configuration.program.idea = "sh " .. configuration.paths.idea
configuration.program.android_studio = "/home/data/Programs/android-studio/bin/studio.sh"
configuration.program.pycharm = "/home/data/Programs/pycharm/bin/pycharm.sh"
configuration.program.filemanager = "thunar"
configuration.program.vbox = "virtualbox"
configuration.program.libre = "libreoffice"
configuration.program.steam = "steam"
configuration.program.anki = "anki -b /home/data/programs_dir/anki"

configuration.cmd = {}
configuration.cmd.terminal = "sakura"
configuration.cmd.editor = "vim"
configuration.cmd.browser = configuration.program.browser
configuration.cmd.system_lock = "slock"
configuration.cmd.system_reboot = "reboot"
configuration.cmd.system_poweroff = "shutdown now"
configuration.cmd.screenshoot_window = "xfce4-screenshooter -w"
configuration.cmd.screenshoot_screen = "xfce4-screenshooter -f"
configuration.cmd.finder = "xfce4-appfinder"
configuration.cmd.compmgr = "unagi"
configuration.cmd.compmgr_args = ""
configuration.cmd.debug_awesome = configuration.paths.conf .. "/meta/scripts/test_awesome_new.sh"

configuration.program_list = {
    configuration.program.browser,
    configuration.program.filemanager,
    configuration.program.keymanager,
    configuration.program.vbox,
    configuration.program.libre,
    configuration.program.steam,
    "zathura",
    "sakura"
}

-- Options {{{
configuration.options = {}

-- keyboard settings {{{
configuration.options.keyboard = {
    layouts = {
        {
            name = "ru",
            args = "",
            vis = "RU"
        },
        {
            name = "en",
            args = "",
            vis = "EN"
        }
    },
    delay = 200,
    repeat_rate = 80
}
-- }}}

-- client settings {{{
configuration.options.client = {
    titlebars_enabled = true,
    opacity = 0.95,
    opacity_max = 1,
    opacity_min = 0.4,
    opacity_step = 0.05
}
-- }}}

-- layout settings {{{
configuration.options.layout_list = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.max.fullscreen,
}
-- }}}

-- tags settings {{{
configuration.options.tags = {
    count = 5,
    names = {
        "1",
        "2",
        "3",
        "4",
        "5"
    },
    layouts = {
        configuration.options.layout_list[2],
        configuration.options.layout_list[2],
        configuration.options.layout_list[2],
        configuration.options.layout_list[2],
        configuration.options.layout_list[2]
    }
}
-- }}}

-- defaults {{{
configuration.default = {
    layout = configuration.options.layout_list[2],
    mwfact = 0.5,
    nmaster = 1,
    ncol = ncol
}
-- }}}

-- }}}

configuration.grabbers = {}
configuration.grabbers.client_grabber = nil
configuration.grabbers.client_target = nil

configuration.grabbers.state_selection = 1
configuration.grabbers.state_resizing  = 2
configuration.grabbers.state_moving    = 3
configuration.grabbers.state_pointer    = 4

configuration.grabbers.client_current_state = configuration.grabbers.state_selection

configuration.func = {}

-- {{{ Grabbers
-- callback for client grabber
configuration.func.grabber_client_callback = function(mod_table, key, event)
    if event == "release" then return end

    local power = 5
    local cl = configuration.grabbers.client_target

--    local mod_pressed = false
--    local alt_pressed = false
--    local ctrl_pressed = false
--    local shift_pressed = false

--    for i, mod in ipairs(mod_table) do
--        if      mod == configuration.constant.key.mod then
--            mod_pressed = true
--
--        elseif  mod == configuration.constant.key.alt then
--            alt_pressed = true
--
--        elseif  mod == configuration.constant.key.ctrl then
--            ctrl_pressed = true
--
--        elseif  mod == configuration.constant.key.shift then
--            shift_pressed = true
--        end
--    end

--    if shift_pressed then
--        power = power * 5
--    end
--
--    if alt_pressed then
--        power = power * 5
--    end
--
--    if ctrl_pressed then
--        power = power * 5
--    end
--
--    if mod_pressed then
--        power = power * 5
--    end

    if (configuration.grabbers.client_current_state == configuration.grabbers.state_selection) then
        if      key == 'q' then
            awful.keygrabber.stop(configuration.grabbers.client_grabber)
        elseif  key == 'r' then
            configuration.grabbers.client_current_state = configuration.grabbers.state_resizing
        elseif  key == 'm' then
            configuration.grabbers.client_current_state = configuration.grabbers.state_moving
        elseif  key == 'p' then
            configuration.grabbers.client_current_state = configuration.grabbers.state_pointer
        end

    elseif (configuration.grabbers.client_current_state == configuration.grabbers.state_resizing) then

        if      key == 'q' then
            configuration.grabbers.client_current_state = configuration.grabbers.state_selection
        elseif     key == 'k'   then
            awful.client.moveresize(0, 0, 0, -power, cl)
        elseif  key == 'j' then
            awful.client.moveresize(0, 0, 0, power, cl)
        elseif  key == 'l' then
            awful.client.moveresize(0, 0, power, 0, cl)
        elseif  key == 'h'  then
            awful.client.moveresize(0, 0, -power, 0, cl)
        end

    elseif (configuration.grabbers.client_current_state == configuration.grabbers.state_moving) then
        if      key == 'q' then
            configuration.grabbers.client_current_state = configuration.grabbers.state_selection
        elseif  key == 'k' then
            awful.client.moveresize(0, -power, 0, 0, cl)
        elseif  key == 'j' then
            awful.client.moveresize(0, power, 0, 0, cl)
        elseif  key == 'l' then
            awful.client.moveresize(power, 0, 0, 0, cl)
        elseif  key == 'h' then
            awful.client.moveresize(-power, 0, 0, 0, cl)
        end
    elseif (configuration.grabbers.client_current_state == configuration.grabbers.state_pointer) then
        if      key == 'q' then
            configuration.grabbers.client_current_state = configuration.grabbers.state_selection
        elseif  key == 'k' then
            configuration.func.mouse_diff(0, -power)
        elseif  key == 'j' then
            configuration.func.mouse_diff(0, power)
        elseif  key == 'l' then
            configuration.func.mouse_diff(power, 0)
        elseif  key == 'h' then
            configuration.func.mouse_diff(-power, 0)
        elseif  key == 'p' then
            configuration.func.mouse_diff_polar(55, power)
        elseif  key == 'o' then
            configuration.func.mouse_diff_polar(35, power)
        elseif  key == 'i' then
            configuration.func.mouse_diff_polar(15, power)
        elseif  key == 'u' then
            configuration.func.mouse_diff_polar(335, power)
        elseif  key == 'y' then
            configuration.func.mouse_diff_polar(315, power)
        elseif  key == 'n' then
            configuration.func.mouse_diff_polar(225, power)
        elseif  key == 'm' then
            configuration.func.mouse_diff_polar(185, power)
        elseif  key == ',' then
            configuration.func.mouse_diff_polar(165, power)
        elseif  key == '.' then
            configuration.func.mouse_diff_polar(135, power)
        elseif  key == ';' then
            configuration.func.mouse_diff_polar(90, power)
        elseif  key == "f" then
            configuration.func.mouse_click(1)
        elseif  key == "d" then
            configuration.func.mouse_click(3)
        elseif  key == "r" then
            configuration.func.mouse_click(4)
        elseif  key == "e" then
            configuration.func.mouse_click(5)
        end
    end
end

configuration.func.grabber_client_run = function(c)
    local cl = c or client.focus
    if (cl) then
        configuration.grabbers.client_target = cl
        configuration.grabbers.client_grabber = awful.keygrabber.run(
            configuration.func.grabber_client_callback
        )
    end
end
-- }}}

-- {{{ Util function
-- Reads all file content. Returns it's content if it's ok, nil otherwise {{{
configuration.func.read_all_file_content = function(filepath)
    local f = io.open(filepath, "r")

    if f ~= nil then
        local content = f:read("*all")
        f:close()
        return content
    end

    return nil
end
-- }}}

-- Parse json from string. Returns parsed json if it's ok, nil otherwise {{{
configuration.func.parse_json = function(json_string)
    local jsoned = json.decode(json_string)
    return jsoned
end
-- }}}

-- Parses json from the file. Returns parsed content of the file if all is ok, nil otherwise. {{{
configuration.func.parse_json_from_file = function(filepath)
    local content = configuration.func.read_all_file_content(filepath)

    if content ~= nil then
        local jsoned = json.decode(content)

        if jsoned ~= nil then
            return jsoned
        end
    end

    return nil
end
-- }}}

configuration.func.real_scr_to_virtual = function(real_scr)
    if (configuration.screens ~= nil and real_scr ~= nil) then
        for i, scr in ipairs(configuration.screens) do
            if scr.screen_real_number == real_scr then
                return scr.screen_number
            end
        end
    end

    return nil
end

configuration.func.mouse_click = function(button)
    awful.util.spawn("xdotool click " .. button)
end

configuration.func.mouse_diff_polar = function(angle, distance)
    awful.util.spawn("xdotool mousemove_relative --polar --sync -- " .. angle .. " " .. distance)
end

configuration.func.mouse_diff = function(diffX, diffY)
    awful.util.spawn("xdotool mousemove_relative --sync -- " .. diffX .. " " .. diffY)
end

configuration.func.get_left_screen = function()
    local scr = configuration.screens.selected
    scr = scr - 1

    if (scr < 1) then
        scr = screen.count()
    end

    return scr
end

configuration.func.get_right_screen = function()
    local scr = configuration.screens.selected
    scr = scr + 1

    if (scr > screen.count()) then
        scr = 1
    end

    return scr
end
-- }}}

configuration.func.cycle_keyboard_layout = function()
    layout_widget:switch()
end

configuration.func.toggle_redshift = function()
    redshift_widget:toggle()
end

configuration.func.run_program = function(s)
    local inner_runner = function()
        awful.util.spawn_with_shell(s)
    end

    return inner_runner
end

configuration.func.debug_awesome = function()
    awful.util.spawn_with_shell(configuration.cmd.debug_awesome)
end

configuration.func.layout_inc = function()
    awful.layout.inc(configuration.options.layout_list, 1)
end

configuration.func.layout_dec = function()
    awful.layout.inc(configuration.options.layout_list, -1)
end

configuration.func.run_terminal = function()
    awful.util.spawn_with_shell(configuration.cmd.terminal)
end

configuration.func.run_browser = function()
    awful.util.spawn_with_shell(configuration.cmd.browser)
end

configuration.func.edit_config = function()
    awful.util.spawn_with_shell(configuration.cmd.terminal .. " -e " .. configuration.cmd.editor .. " " .. awesome.conffile)
end

configuration.func.increase_opacity = function()
    local client_options = configuration.options.client

    if client_options.opacity < client_options.opacity_max then
        client_options.opacity = client_options.opacity + client_options.opacity_step
    end

    if client_options.opacity > client_options.opacity_max then
        client_options.opacity = client_options.opacity_max
    end
end

configuration.func.decrease_opacity = function()
    local client_options = configuration.options.client

    if client_options.opacity > client_options.opacity_min  then
        client_options.opacity = client_options.opacity - client_options.opacity_step
    end

    if client_options.opacity < client_options.opacity_min then
        client_options.opacity = client_options.opacity_max
    end
end

configuration.func.exec_prompt = function()
    local scr = configuration.screens.selected
    awful.prompt.run(
    {prompt = "Write program name:  "},
        configuration.screens[scr].promptbox,
        function (t)
            awful.util.spawn_with_shell(t)
        end,
        function (t, p, n)
            return awful.completion.generic(
                t,
                p,
                n,
                configuration.program_list
            )
        end
    )
end

configuration.func.move_mouse = function(x_co, y_co)
    mouse.coords( { x=x_co, y=y_co } )
end

configuration.func.move_mouse_to_right_corner_of_screen = function()
    local scr_num = configuration.screens.selected
    local scr = configuration.screens[scr_num]
    local x_end = scr.x_end
    local y_end = scr.y_end
    configuration.func.move_mouse(x_end, y_end)
end

configuration.func.system_reboot = function()
    local scr = configuration.screens.selected
    awful.prompt.run({prompt = "Reboot (type 'yes' to confirm)? "},
    configuration.screens[scr].promptbox,
    function (t)
        if string.lower(t) == 'yes' then
            awesome.emit_signal("exit", nil)
            awful.util.spawn(configuration.cmd.system_reboot)
        end
    end,
    function (t, p, n)
        return awful.completion.generic(
            t, p, n, {'no', 'NO', 'yes', 'YES'}
        )
    end)
end

configuration.func.system_poweroff = function()
    local scr = configuration.screens.selected
    awful.prompt.run({prompt = "Power Off (type 'yes' to confirm)? "},
    configuration.screens[scr].promptbox,
    function (t)
        if string.lower(t) == 'yes' then
            awesome.emit_signal("exit", nil)
            awful.util.spawn(configuration.cmd.system_poweroff)
        end
    end,
    function (t, p, n)
        return awful.completion.generic(
            t, p, n, {'no', 'NO', 'yes', 'YES'}
        )
    end)
end

configuration.func.system_lock = function()
    awful.util.spawn_with_shell(configuration.cmd.system_lock)
end

configuration.func.run_finder = function()
    awful.spawn(configuration.cmd.finder)
end

configuration.func.brightness_up = function()
    awful.util.spawn_with_shell("xbacklight -up 10")
end

configuration.func.brightness_down = function()
    awful.util.spawn_with_shell("xbacklight -down 10")
end

configuration.func.focus_to_screen = function(scr)
    if (scr < 1) or (scr > screen.count()) then
        return
    end

    configuration.screens.selected = scr
    local real_scr = configuration.screens[scr].screen_real_number
    awful.screen.focus(real_scr)
end

configuration.func.focus_to_left_screen = function()
    local virt_scr = configuration.screens.selected
    local new_virt_scr = configuration.screens[virt_scr].screen_left_number

    configuration.func.focus_to_screen(new_virt_scr)
end

configuration.func.focus_to_right_screen = function()
    local virt_scr = configuration.screens.selected
    local new_virt_scr = configuration.screens[virt_scr].screen_right_number

    configuration.func.focus_to_screen(new_virt_scr)
end

configuration.func.focus_to_top_screen = function()
    local virt_scr = configuration.screens.selected
    local new_virt_scr = configuration.screens[virt_scr].screen_top_number

    configuration.func.focus_to_screen(new_virt_scr)
end

configuration.func.focus_to_bottom_screen = function()
    local virt_scr = configuration.screens.selected
    local new_virt_scr = configuration.screens[virt_scr].screen_bottom_number

    configuration.func.focus_to_screen(new_virt_scr)
end

-- {{{ Client functions

configuration.func.client_swap_to_right = function()
    awful.client.swap.bydirection("right")
end
configuration.func.client_swap_to_up = function()
    awful.client.swap.bydirection("up")
end
configuration.func.client_swap_to_down = function()
    awful.client.swap.bydirection("down")
end
configuration.func.client_swap_to_left = function()
    awful.client.swap.bydirection("left")
end

configuration.func.client_focus_to_left = function()
    awful.client.focus.bydirection("left")
    local cl = client.focus
    if cl then
        cl:raise()
    end
end
configuration.func.client_focus_to_right = function()
    awful.client.focus.bydirection("right")
    local cl = client.focus
    if cl then
        cl:raise()
    end
end
configuration.func.client_focus_to_up = function()
    awful.client.focus.bydirection("up")
    local cl = client.focus
    if cl then
        cl:raise()
    end
end

configuration.func.client_focus_to_down = function()
    awful.client.focus.bydirection("down")
    local cl = client.focus
    if cl then
        cl:raise()
    end
end

configuration.func.client_toggle_titlebar = function(c)
    c = c or client.focus
    if c then
        awful.titlebar.toggle(client.focus)
    end
end

configuration.func.client_focus_next = function()
    awful.client.focus.byidx(1)
    if client.focus then
        client.focus:raise()
    end
end

configuration.func.client_focus_prev = function()
    awful.client.focus.byidx(-11)
    if client.focus then
        client.focus:raise()
    end
end

configuration.func.client_raise = function(c)
  c:raise()
end

configuration.func.client_toggle_fullscreen = function(c)
  c.fullscreen = not c.fullscreen
end

configuration.func.client_maximize_horizontal = function(c)
  c.maximized_horizontal = not c.maximized_horizontal
end

configuration.func.client_maximize_vertical = function(c)
  c.maximized_vertical = not c.maximized_vertical
end

configuration.func.client_maximize = function(c)
  configuration.func.client_maximize_horizontal(c)
  configuration.func.client_maximize_vertical(c)
end

configuration.func.client_minimize = function(c)
  c.minimized = not c.minimized
end

configuration.func.client_opaque_less = function(c)
    local client_options = configuration.options.client
    local opacity = c.opacity - client_options.opacity_step

    if  opacity and
        opacity >= client_options.opacity_min then
            if opacity >= client_options.opacity_max then
                opacity = client
            end
            c.opacity = client_options.opacity_max
    end
end

configuration.func.client_opaque_more = function(c)
    local client_options = configuration.options.client
    local opacity = c.opacity + client_options.opacity_step

    if  opacity and
        opacity <= client_options.opacity_max then
            if opacity <= client_options.opacity_min then
                opacity = client_options.opacity_min
            end
            c.opacity = opacity
    end
end

configuration.func.client_kill = function(c)
    c:kill()
end

configuration.func.client_on_top = function(c)
    c.ontop = not c.ontop
end

configuration.func.client_focus = function(c)
    c = c or client.focus
    if c then
        client.focus = c;
        c:raise()
    end
end

configuration.func.move_to_target_screen = function(c, scr_number)
    local cl = c or awful.client.focus
    if (cl) then
        configuration.screens.selected = scr_number
        local real_scr = configuration.screens[scr_number].screen_real_number
        awful.client.movetoscreen(cl, real_scr)
    end
end

configuration.func.move_to_target_tag = function(c, tag_number)
    c = c or client.focus
    if not c then
        return
    end

    local scr = configuration.screens.selected
    local real_scr_number = configuration.screens.mapper[scr]
    local tags_table = configuration.screens[real_scr_number]

    if  tag_number < 1 or
        tag_number > #tags_table then
            return
    end

    local tag = tags_table[tag_number]
    if tag then
        awful.client.movetotag(tag, c)
    end

end

configuration.func.move_to_left_tag = function(c)

end

-- }}}

-- {{{ Tag functions

configuration.func.tag_view_prev = awful.tag.viewprev

configuration.func.tag_view_next = awful.tag.viewnext

-- }}}

read_config_files = function()
    -- screens
    configuration.screens = configuration.func.parse_json_from_file(
        configuration.paths.config_screens
    )

    configuration.screens.selected = 2

    for index, screen in ipairs(configuration.screens) do
        screen.x_end = screen.x_beg + screen.width - 1
        screen.y_end = screen.y_beg + screen.height - 1
    end

    -- wallpapers
    configuration.wallpapers = configuration.func.parse_json_from_file(
        configuration.paths.config_wallpapers
    )
end

setup_xrandr = function()
    local command = "xrandr"

    for index, screen in ipairs(configuration.screens) do
        command = command .. string.format(
            " --output %s --mode %dx%d --pos %dx%d --rotate normal ",
            screen.name,
            screen.width,
            screen.height,
            screen.x_beg,
            screen.y_beg
        )
    end

    awful.util.spawn(command)
end

setup_error_handler = function()
    if awesome.startup_errors then
        naughty.notify(
            {
                preset = naughty.config.presets.critical,
                title = "Loading error",
                text = awesome.startup_errors
            }
        )
    end

    do
        local in_error = false
        awesome.connect_signal("debug::error", function (err)
            if in_error then return end
            in_error = true

            naughty.notify({ preset = naughty.config.presets.critical,
            title = "Runtime error",
            text = err })
            in_error = false
        end)
    end
end

setup_theme = function()
    beautiful.init(configuration.paths.theme)

    -- bug: idk why, but screen's wallpapers are setted in a fixed order
    for s = 1, screen.count() do
--        local real_scr = configuration.screens.mapper[s]
--        local selected_scr = configuration.screens[real_scr]
--
--        if selected_scr.custom_wallpaper then
--            gears.wallpaper.maximized(selected_scr.wallpaper_path, s, true)
--        else
--            gears.wallpaper.maximized(configuration.paths.wallpaper, s, true)
--        end
    end

    for i, wallpaper in ipairs(configuration.wallpapers) do
         local real_scr = configuration.screens[wallpaper.screen_number].screen_real_number
         if real_scr > 0 and real_scr <= screen.count() then
             gears.wallpaper.maximized(wallpaper.wallpaper_path, real_scr, true)
         end
    end
end

setup_x_server = function()
    awful.util.spawn_with_shell(
        "xset r rate " .. configuration.options.keyboard.delay
        .. " " .. configuration.options.keyboard.repeat_rate
    )
end

setup_tags = function()
    for s = 1, screen.count() do
        local real_screen_number = configuration.screens[s].screen_real_number
        configuration.screens[real_screen_number].tags = awful.tag(
            configuration.options.tags.names,
            s,
            configuration.options.tags.layouts
        )
    end
end

setup_menu = function()
    configuration.menu.awesome = {
        { "restart", awesome.restart },
        { "quit", awesome.quit }
    }

    configuration.menu.main = awful.menu({ items = {
        { "awesome", configuration.menu.awesome, beautiful.awesome_icon },
        { "open terminal", configuration.cmd.terminal }
    }
})
end

setup_screen_border = function()
    mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                         menu = configuration.menu.main })

    menubar.utils.terminal = configuration.cmd.terminal

    mytextclock = awful.widget.textclock()

    mywibox = {}
    mypromptbox = {}
    mytaglist = {}
    mytaglist.buttons = awful.util.table.join(
                        awful.button({ }, 1, awful.tag.viewonly)
                        )
    mytasklist = {}
    mytasklist.buttons = awful.util.table.join(
                             awful.button({ }, 1,
                             function (c)
                                 if c == client.focus then
                                     c.minimized = true
                                 else
                                     c.minimized = false
                                     if not c:isvisible() then
                                         awful.tag.viewonly(c:tags()[1])
                                     end
                                     client.focus = c
                                     c:raise()
                                 end
                             end)
                         )

    for s = 1, screen.count() do
        local layoutbox_buttons = awful.util.table.join(
            awful.button({ }, 1, configuration.func.layout_inc),
            awful.button({ }, 3, configuration.func.layout_dec)
        )

        local scr_number = configuration.screens[s].screen_real_number
        local scr = configuration.screens[scr_number]

        scr.promptbox = wibox.widget.textbox()

        scr.layoutbox = awful.widget.layoutbox(s)
        scr.layoutbox:buttons(awful.util.table.join(layoutbox_buttons))

        scr.taglist = awful.widget.taglist(
            s,
            awful.widget.taglist.filter.all,
            mytaglist.buttons
        )

        scr.tasklist = awful.widget.tasklist(
            s,
            awful.widget.tasklist.filter.currenttags,
            mytasklist.buttons
        )

        scr.wibox_top = awful.wibox({ position = "top", screen = s })
        scr.wibox_bottom = awful.wibox({ position = "bottom", screen = s })
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(scr.taglist)
        left_layout:add(scr.promptbox)

        local right_layout = wibox.layout.fixed.horizontal()

        if s == 1 then
            right_layout:add(wibox.widget.systray())
            right_layout:add(redshift_widget.widget)
        end

        right_layout:add(memory_widget.widget_text)
        right_layout:add(memory_widget.widget_progress)
        right_layout:add(cpu_widget.text)
        right_layout:add(cpu_widget.widget_progress)

        if battery_widget.has_battery then
            right_layout:add(battery_widget.widget_text)
            right_layout:add(battery_widget.widget_progress)
        end

        right_layout:add(volume_widget.widget_text)
        right_layout:add(volume_widget.widget_progress)
        right_layout:add(layout_widget.widget)
        right_layout:add(mytextclock)
        right_layout:add(scr.layoutbox)

        local top_layout = wibox.layout.align.horizontal()
        top_layout:set_left(left_layout)
        top_layout:set_right(right_layout)

        local bottom_layout = wibox.layout.align.horizontal()
        bottom_layout:set_middle(scr.tasklist)
        bottom_layout:set_left(mylauncher)

        scr.wibox_top:set_widget(top_layout)
        scr.wibox_bottom:set_widget(bottom_layout)
    end
end

setup_keys = function()
    root.buttons(awful.util.table.join(
        awful.button({ }, 3,
            function()
                configuration.menu.main:toggle()
            end
        )
    ))

    local keys = configuration.constant.key
    globalkeys = awful.util.table.join()

    globalkeys = awful.util.table.join(globalkeys,
    -- change focus of clients
        awful.key({ keys.mod },
            "h", configuration.func.client_focus_to_left),
        awful.key({ keys.mod },
            "j", configuration.func.client_focus_to_down),
        awful.key({ keys.mod },
            "k", configuration.func.client_focus_to_up),
        awful.key({ keys.mod },
            "l", configuration.func.client_focus_to_right),

        awful.key({ keys.mod },
            keys.left, awful.tag.viewprev),
        awful.key({ keys.mod },
            keys.right, awful.tag.viewnext),

    -- swap clients
        awful.key({ keys.mod, keys.shift },
            "h", configuration.func.client_swap_to_left),
        awful.key({ keys.mod, keys.shift },
            "j", configuration.func.client_swap_to_down),
        awful.key({ keys.mod, keys.shift },
            "k", configuration.func.client_swap_to_up),
        awful.key({ keys.mod, keys.shift },
            "l", configuration.func.client_swap_to_right),

        awful.key({ keys.mod },
            "d", configuration.func.debug_awesome),

        awful.key({ keys.mod, keys.ctrl },
            keys.space, configuration.func.layout_inc),
        awful.key({ keys.mod, keys.ctrl, keys.shift },
            keys.space, configuration.func.layout_dec)
    )

    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ keys.ctrl, keys.mod, keys.alt },
            keys.enter, configuration.func.exec_prompt),

        awful.key({ keys.mod },
            keys.enter, configuration.func.run_terminal),

        awful.key({ keys.ctrl, keys.mod },
            keys.enter, configuration.func.edit_config)
    )

    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ keys.ctrl, keys.alt, keys.mod },
            'm', configuration.func.move_mouse_to_right_corner_of_screen)
    )

    local programs = configuration.program

    -- {{{ Program launchers
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ keys.ctrl, keys.alt, keys.mod },
            "b", configuration.func.run_program(programs.browser)),
        awful.key({ keys.ctrl, keys.alt, keys.mod },
            "k", configuration.func.run_program(programs.keymanager)),
        awful.key({ keys.ctrl, keys.alt, keys.mod },
            "i", configuration.func.run_program(programs.idea)),
        awful.key({ keys.ctrl, keys.alt, keys.mod },
            "a", configuration.func.run_program(programs.android_studio)),
        awful.key({ keys.ctrl, keys.alt, keys.mod },
            "f", configuration.func.run_program(programs.filemanager)),
        awful.key({ keys.ctrl, keys.alt, keys.mod },
            "f", configuration.func.run_program(programs.thunar)),
        awful.key({ keys.ctrl, keys.alt, keys.mod },
            "v", configuration.func.run_program(programs.vbox)),
        awful.key({ keys.ctrl, keys.alt, keys.mod },
            "l", configuration.func.run_program(programs.libre)),
        awful.key({ keys.ctrl, keys.alt, keys.mod },
            "s", configuration.func.run_program(programs.steam)),
        awful.key({ keys.ctrl, keys.alt, keys.mod },
            "d", configuration.func.run_program(programs.anki)),
        awful.key({ keys.ctrl, keys.alt, keys.mod },
            "p", configuration.func.run_program(programs.pycharm)),

        -- redshift
        awful.key({ keys.ctrl, keys.alt, keys.mod },
            "r", configuration.func.toggle_redshift),

        awful.key({ keys.ctrl, keys.alt },
            keys.delete, configuration.func.system_lock)
    )

    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ keys.ctrl, keys.alt, keys.mod },
            keys.num_1, configuration.func.run_program(programs.browser_1)),
        awful.key({ keys.ctrl, keys.alt, keys.mod },
            keys.num_2, configuration.func.run_program(programs.browser_2)),
        awful.key({ keys.ctrl, keys.alt, keys.mod },
            keys.num_3, configuration.func.run_program(programs.browser_3))
    )

    -- }}}

    -- System management {{{
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ keys.ctrl, keys.mod },
            "q", awesome.quit),
        awful.key({ keys.ctrl, keys.mod },
            "r", awesome.restart),
        awful.key({ keys.ctrl, keys.mod },
            "s", configuration.func.system_poweroff),
        awful.key({ keys.ctrl, keys.mod },
            "e", configuration.func.system_reboot)
    )
    -- }}}

    -- Focus monitors {{{
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ keys.ctrl, keys.mod },
            "h", configuration.func.focus_to_left_screen),
        awful.key({ keys.ctrl, keys.mod },
            "l", configuration.func.focus_to_right_screen)
    )
    -- }}}

    -- Light {{{
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ }, keys.brightness_up,
        function()
            awful.util.spawn_with_shell("xbacklight -inc 10")
        end),

        awful.key ({ }, keys.brightness_down,
        function()
            awful.util.spawn_with_shell("xbacklight -dec 10")
        end)
    )
    -- }}}

    -- {{{ Volume control
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ }, keys.volume_up,
        function()
            volume_widget.up()
        end),
        awful.key ({ }, keys.volume_down,
        function()
            volume_widget.down()
        end),
        awful.key ({ }, keys.volume_mute,
        function()
            volume_widget.toggle()
        end)
    )
-- }}}

-- {{{ Screenshots

    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ }, "Print",
                    function()
                        awful.util.spawn_with_shell(configuration.cmd.screenshoot_window)
                    end),
        awful.key ({ keys.ctrl }, "Print",
                    function()
                        awful.util.spawn_with_shell(configuration.cmd.screenshoot_screen)
                    end)
    )

-- }}}

    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ keys.mod },
            keys.tab, configuration.func.client_focus_next),

        awful.key({ keys.mod },
            keys.space, configuration.func.cycle_keyboard_layout)
    )

    -- Tags {{{
    for i = 1, configuration.options.tags.count do
        globalkeys = awful.util.table.join(globalkeys,
            awful.key({ keys.mod }, "#" .. i + 9,
            function()
                local screen = configuration.screens.selected
                local tag = configuration.screens[screen].tags[i]
                if tag then
                    awful.tag.viewonly(tag)
                end
            end
            ),
            awful.key({ keys.mod, keys.shift }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = awful.tag.gettags(client.focus.screen)[i]
                    if tag then
                        awful.client.movetotag(tag)
                    end
                end
            end)
        )
    end
    -- }}}


    clientkeys = awful.util.table.join(
        awful.key({ keys.mod },
            "q", configuration.func.client_kill),
        awful.key({ keys.mod },
            "t", configuration.func.client_toggle_titlebar),
        awful.key({ keys.mod },
            "m", configuration.func.client_maximize),
        awful.key({ keys.mod },
            "h", configuration.func.client_minimize),
        awful.key({ keys.mod },
            "f", awful.client.floating.toggle),
        awful.key({ keys.mod },
            "o", configuration.func.client_on_top),
        awful.key({ keys.mod },
            keys.enter, configuration.func.grabber_client_run)
    )


    clientbuttons = awful.util.table.join(
        awful.button({ }, 1, configuration.func.client_focus),
        awful.button({ keys.mod }, 1, awful.mouse.client.move),
        awful.button({ keys.mod }, 3, awful.mouse.client.resize)
    )

    -- Screen keys{{{

    for index, screen in ipairs(configuration.screens) do
        globalkeys = awful.util.table.join(
            globalkeys,
            awful.key( { keys.mod, keys.ctrl },
                "#" .. index + 9,
                function()
                    configuration.func.focus_to_screen(index)
                end
            )
        )

        clientkeys = awful.util.table.join(
            clientkeys,
            awful.key( { keys.mod, keys.shift, keys.ctrl },
                "#" .. index + 9,
                function(c)
                    configuration.func.move_to_target_screen(c, index)
                end
            )
        )
    end

    -- }}}

    root.keys(globalkeys)
end

setup_rules = function()
    keys = configuration.constant.key


    awful.rules.rules = {
        {
            rule = { },
            properties = {
                border_width = beautiful.border_width,
                border_color = beautiful.border_normal,
                focus = awful.client.focus.filter,
                raise = true,
                keys = clientkeys,
                buttons = clientbuttons 
            }
        },

        -- ^_^
        { rule = { class = "Everlasting Summer" },
          properties = {
              maximized_horizontal = true,
              maximized_horizontal = true,
              floating = false,
              ontop = true
          }
        },
        { rule = { class = "SMPlayer" },
            properties = {
                floating = true,
                ontop = true
            }
        },
        { rule = { class = "wicd-client.py" },
            properties = {
                floating = true,
                ontop = true
            }
        },
        { rule = { class = "Wicd-client.py" },
            properties = {
                floating = true,
                ontop = true
            }
        },
        { rule = { class = "chromium" },
            properties = {
                maximized_horizontal = false,
                maximized_vertical = false,
                floating = false
            }
        },
        { rule = { class = "Blueberry.py" },
            properties = {
                floating = true
            }
        }

    }
end

setup_signals = function()
    client.connect_signal("manage", function (c, startup)
        c:connect_signal("mouse::enter", function(c)
            if  awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                and awful.client.focus.filter(c) then
                    client.focus = c
            end

            -- change screens.selected
            local scr_num = configuration.func.real_scr_to_virtual(c.screen)
            configuration.screens.selected = scr_num
        end)

        if not startup then
            if  not c.size_hints.user_position and
                not c.size_hints.program_position then
                    awful.placement.no_overlap(c)
                    awful.placement.no_offscreen(c)
            end
        end

        if  (configuration.options.client.titlebars_enabled) and 
            (c.type == "normal" or c.type == "dialog") then
                local buttons = awful.util.table.join()

                local left_layout = wibox.layout.fixed.horizontal()
                left_layout:add(awful.titlebar.widget.iconwidget(c))

                local right_layout = wibox.layout.fixed.horizontal()

                local title = awful.titlebar.widget.titlewidget(c)
                title:set_align("center")

                local middle_layout = wibox.layout.flex.horizontal()
                middle_layout:add(title)

                local layout = wibox.layout.align.horizontal()
                layout:set_left(left_layout)
                layout:set_middle(middle_layout)
                layout:set_right(right_layout)

                awful.titlebar(c):set_widget(layout)
        end
    end)

    client.connect_signal("focus",
        function(c)
            c.border_color = beautiful.border_focus
            c.opacity = configuration.options.client.opacity_max
        end
    )

    client.connect_signal("unfocus",
        function(c)
            c.border_color = beautiful.border_normal
            c.opacity = configuration.options.client.opacity
        end
    )
end

read_config_files()
setup_xrandr()
setup_error_handler()
setup_theme()
setup_x_server()
setup_tags()
setup_menu()
setup_screen_border()
setup_keys()
setup_rules()
setup_signals()

-- debug stuff
