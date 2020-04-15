#!/bin/bash

##############################################################################
#Предварительно подключите репозитории Debian Wheezy
#можете воспользоваться скриптом Debian_Wheezy_Repo.sh В в этом репозитории
##############################################################################

#установка conky и cmatrix
sudo aptitude install conky cmatrix

echo 'Настраиваю Conky для $LOGNAME'
#создаю conkyrc, замените при желании своим конфигом
cat > /home/$LOGNAME/.conkyrc <<EOF
alignment top_right
background false
border_width 1
cpu_avg_samples 2
default_color white
default_outline_color grey
default_shade_color black
draw_borders false
draw_graph_borders false
draw_outline true
draw_shades true
use_xft true
font PT Mono:size=12
gap_x 100
gap_y 60
net_avg_samples 2
out_to_console false
double_buffer true
out_to_stderr true
extra_newline false
own_window true
own_window_class Conky
own_window_type override
own_window_transparent true
stippled_borders 0
update_interval 1.0
uppercase false
use_spacer none
show_graph_scale false
show_graph_range false

TEXT
\${font PT Mono:size=58}\${time %k:%M:%S}\${font}
\${alignc}\${font Hack:size=12}\${time %A %d, %Y}\${font}
EOF

echo 'Настраиваю запуск Conky при включении компьютера'
cat > /home/$LOGNAME/.config/autostart/conky.desktop <<EOF
[Desktop Entry]
Type = Application
NoDisplay = false
Exec = /usr/bin/conky
Icon = dashboard-show
X-FLY-IconContext = Actions
Hidden = false
Terminal = false
StartupNotify = false
EOF