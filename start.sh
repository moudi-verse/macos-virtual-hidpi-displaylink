#!/bin/zsh

cd ~/virtual-hidpi

# start virtual display
./virtual_hidpi_display &

# wait for macOS to register it
sleep 3

# apply your layout (PASTE YOUR displayplacer command
displayplacer "id:85D9D7EE-61D7-EFBF-0857-D6964E3302DB res:2048x1152 hz:75 color_depth:8 enabled:true scaling:on origin:(0,0) degree:0" "id:3C5298E6-B1A0-FD5B-9DE9-0966D8C1CFC8+97F39B4A-3B90-5016-C90B-A2661D91F570 res:2048x1152 hz:60 color_depth:4 enabled:true scaling:on origin:(2048,0) degree:0"

