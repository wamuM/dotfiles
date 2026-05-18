#!/usr/bin/env bash
if [[ -z "$*" ]];then
    xdotool getwindowfocus set_window --name "terminal"
else
    xdotool getwindowfocus set_window --name "$*" 
fi
