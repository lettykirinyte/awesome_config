#!/bin/bash
Xephyr -ac -br -noreset -screen 1024x768 :1.0 &
ZEPHYR_PID=$!
sleep 1
DISPLAY=:1.0 awesome -c /home/mezzari/.config/awesome/rc.lua
kill $ZEPHYR_PID
