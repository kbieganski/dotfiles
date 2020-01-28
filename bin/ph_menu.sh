#!/bin/sh

expect -c \
    "spawn passhole --no-cache type --prog \"rofi -dmenu\"
     expect \"Enter database password (passwords):\"
     send -- $(zenity --password)\n
     expect eof"
