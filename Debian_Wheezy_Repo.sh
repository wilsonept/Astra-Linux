#!/bin/bash

echo "Добавляю репозиторий Debian Wheezy в /etc/apt/sources.list"

echo "deb http://archive.debian.org/debian/ wheezy contrib main non-free" | sudo tee -a /etc/apt/sources.list

echo "Добавляю ключи для репозитория Debian Wheezy в /etc/apt/sources.list"

#Однострочник, работает когда aptitude выдает ошибку ключей. Фильтрует вывод, получая только номера отсутствующих ключей,
#и каждый из этих ключей ищет на сервере - в данном случае "keyserver.ubuntu.com"
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com `sudo aptitude update 2>&1 | grep -o '[0-9A-Z]\{16\}$'| xargs`

sudo aptitude update