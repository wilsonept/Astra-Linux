#!/bin/bash

echo "Добавляю репозитории LAB50 в /etc/apt/sources.list.d/lab50.list"

echo "deb http://packages.lab50.net/se15/ smolensk main" | sudo tee /etc/apt/sources.list.d/lab50.list
echo "deb-src http://packages.lab50.net/se15/ smolenskmain" | sudo tee -a /etc/apt/sources.list.d/lab50.list
echo "deb http://packages.lab50.net/security/se15 smolensk main contrib non-free" | sudo tee -a /etc/apt/sources.list.d/lab50.list

echo "Добавляю ключ для репозиториев LAB50"

wget -qO - http://packages.lab50.net/lab50.asc | sudo apt-key add -

sudo aptitude update && sudo aptitude -y install lab50-archive-keyring locate
sudo aptitude -y upgrade