#!/bin/bash

echo "Добавляю репозиторий OPERA"

echo "deb http://deb.opera.com/opera-stable/ stable non-free" | sudo tee -a /etc/apt/sources.list

echo "Добавляю ключ для репозитория OPERA"

wget -qO - http://deb.opera.com/archive.key | sudo apt-key add -

sudo aptitude update

sudo aptitude install opera