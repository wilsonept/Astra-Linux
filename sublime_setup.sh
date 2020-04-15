#!/bin/bash

echo 'Устанавливаю Sublime 2'

cd /home/$LOGNAME/Загрузки

wget -q https://download.sublimetext.com/Sublime%20Text%202.0.2%20x64.tar.bz2

tar -x -f Sublime\ Text\ 2.0.2\ x64.tar.bz2 -C /opt

sudo ln -s /opt/Sublime\ Text\ 2/sublime_text /bin/sublime

#Что бы запустить программу введите в терминале sublime