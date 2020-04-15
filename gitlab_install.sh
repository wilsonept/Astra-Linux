#!/bin/bash

##############################################################################
#Предварительно подключите репозитории Debian Wheezy
#можете воспользоваться скриптом Debian_Wheezy_Repo.sh В в этом репозитории
##############################################################################

read -p "Введите имя этого компьютера: " HOSTNAME
read -p "Введите имя домена (пример:domain.local): " DOMAIN

echo 'Устанавливаю GITLAB'

cd /home/$LOGNAME/Загрузки
wget -q http://packages.gitlab.com/gitlab/gitlab-ce/packages/debian/wheezy/gitlab-ce_10.0.0-ce.0_amd64.deb/download.deb

#изменяем имя хоста
#возможно надо изменить строку с именем в /etc/hosts
#заработало когда в /etc/hostname было короткое имя, а в /etc/hosts полное и короткое
sudo hostname $HOSTNAME.$DOMAIN

#отключаем апач что бы гит не выдавал ошибку 80 порта
sudo /etc/init.d/apache2 stop
sudo service apache2 disable

sudo dpkg -i download.deb
#необходимо в файле /etc/gitlab/gitlab.rb заменть external_url на 'http://полноеимякомпутера'
#sudo vim /etc/gitlab/gitlab.rb
#замена строки external_url через sed с помощью регулярного выражения
#флаг -i записывает изменения в файл
#шаблон располагается между s/ (это и есть замена) и /1 (количеством выполнений замен)
PATTERN="s/^external_url.*/external_url 'http:\/\/$HOSTNAME.$DOMAIN'/1"
sudo sed -i "$PATTERN" /etc/gitlab/gitlab.rb

sudo gitlab-ctl reconfigure

echo 'Зарегистрируйте аккаунт если это необходимо'
firefox http://gitlab.cniiag.local

echo 'Устанавливаю GIT'
sudo aptitude install git

read -p "введите имя проекта в GITLAB: " PROJECT_NAME
read -p "введите полное имя будущей директории гита: " GIT_DIR

sudo mkdir $GIT_DIR
cd $GIT_DIR

echo 'Создаю .gitignore'
cat > $GIT_DIR/.gitignore <<EOF
*.txt~
*.sh~
EOF
echo 'Инициализирую Git'
git init
git add .
git commit -m 'Git Initialization'
git remote add origin http://$HOSTNAME.$DOMAIN/$LOGNAME/$PROJECT_NAME.git
git config --global user.name "$LOGNAME"
git config --global user.email "$LOGNAME@$DOMAIN"
git config --global push.default simple
git push