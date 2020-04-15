#!/bin/bash

############################################################################################################################################
#Недописаный сборник
############################################################################################################################################

#разблокируем root
#sudo passwd –u root
#Задаем пароль рута
#sudo passwd root
#Заблокировать рута
#sudo usermod –e 1 root

#БУДУЩЕЕ РАЗРЕШЕНИЕ ЭКРАНА
xrandr | grep -o '[0-9]\{3,4\}x[0-9]\{3,4\}'
read -p "Введите предпочитаемое разрешение из списка выше: " RESOLUTION
read -p "Введите имя этого компьютера: " HOSTNAME
read -p "Введите имя домена (пример:domain.local): " DOMAIN
read -p "введите имя проекта в GITLAB: " PROJECT_NAME
read -p "введите полное имя будущей директории гита: " GIT_DIR
read -n 1 -p "Убедитесь что диск с астрой 1.5 установлен в приводе (y/[n]): " YES
[ "$YES" = "y" ] || exit
echo "" 1>&2

sudo mount /dev/sr0 || exit

############################################################################################################################################
echo "Добавляю репозитории LAB50 в /etc/apt/sources.list.d/lab50.list"
############################################################################################################################################
echo "deb http://packages.lab50.net/se15/ smolensk main" | sudo tee /etc/apt/sources.list.d/lab50.list
echo "deb-src http://packages.lab50.net/se15/ smolenskmain" | sudo tee -a /etc/apt/sources.list.d/lab50.list
echo "deb http://packages.lab50.net/security/se15 smolensk main contrib non-free" | sudo tee -a /etc/apt/sources.list.d/lab50.list
echo "Добавляю ключ для репозиториев LAB50"
wget -qO - http://packages.lab50.net/lab50.asc | sudo apt-key add -

sudo aptitude update && sudo aptitude -y install lab50-archive-keyring locate
sudo aptitude -y upgrade

############################################################################################################################################
echo "Добавляю репозиторий Debian Wheezy в /etc/apt/sources.list"
############################################################################################################################################
echo "deb http://archive.debian.org/debian/ wheezy contrib main non-free" | sudo tee -a /etc/apt/sources.list
echo "Добавляю ключи для репозитория Debian Wheezy в /etc/apt/sources.list"
#Однострочник, работает когда aptitude выдает ошибку ключей.
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com `sudo aptitude update 2>&1 | grep -o '[0-9A-Z]\{16\}$'| xargs`
#sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 8B48AD6246925553
#sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 7638D0442B90D010
#sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 6FB2A1C265FFB764

############################################################################################################################################
echo 'Устанавливаю Sublime 2'
############################################################################################################################################
wget -q https://download.sublimetext.com/Sublime%20Text%202.0.2%20x64.tar.bz2
tar -x -f Sublime\ Text\ 2.0.2\ x64.tar.bz2 -C /opt
sudo ln -s /opt/Sublime\ Text\ 2/sublime_text /bin/sublime

############################################################################################################################################
echo "Добавляю репозиторий OPERA"
############################################################################################################################################
echo "deb http://deb.opera.com/opera-stable/ stable non-free" | sudo tee -a /etc/apt/sources.list
echo "Добавляю ключ для репозитория OPERA"
wget -qO - http://deb.opera.com/archive.key | sudo apt-key add -
sudo aptitude update

############################################################################################################################################
echo 'Устанавливаю крутой стафф'
############################################################################################################################################
#ставим оперу конки и матрих из репов оперы и дебиана
sudo aptitude install opera conky cmatrix winbind curl

############################################################################################################################################
echo "Добавляю закомментированый Astra Orel Repository"
############################################################################################################################################
echo "#deb [trusted=yes] http://mirror.yandex.ru/astra/stable/orel/repository/ orel main contrib non-free" | sudo tee -a /etc/apt/sources.list
echo "Раскоментируйте его при необходимости в /etc/apt/sources.list"

############################################################################################################################################
echo 'Настраиваю Conky для $LOGNAME'
############################################################################################################################################
#создаю conkyrc
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

echo 'Настраиваю запуск Conky при включении'
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


echo 'Настраиваю разрешение экрана при включении'
cat > /home/$LOGNAME/.config/autostart/xrandr.desktop <<EOF
[Desktop Entry]
Type = Application
NoDisplay = false
Exec = xrandr --output Virtual1 --mode $RESOLUTION
Hidden = false
Terminal = false
StartupNotify = false
EOF

############################################################################################################################################
echo 'Устанавливаю стафф покруче =)'
############################################################################################################################################
#Установка Xonotic и TeeWorlds
cd /home/$LOGNAME/Загрузки
wget -q http://dl.xonotic.org/xonotic-0.8.2.zip
unzip xonotic.zip -d /home/wilson/Загрузки/Games/
sudo ln -s /home/$LOGNAME/Загрузки/Games/Xonotic/xonotic-linux-sdl.sh /bin/xonotic
sudo aptitude install teeworlds

############################################################################################################################################
echo 'Устанавливаю GITLAB'
############################################################################################################################################
cd /home/$LOGNAME/Загрузки
wget -q http://packages.gitlab.com/gitlab/gitlab-ce/packages/debian/wheezy/gitlab-ce_10.0.0-ce.0_amd64.deb/download.deb
#изменяем именя хоста
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
#wget -q http://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
#репозиторий переехал
#echo "deb http://packages.gitlab.com/gitlab/gitlab-ce/debian/ wheezy main" | sudo tee -a /etc/apt/sources.list

############################################################################################################################################
echo 'Устанавливаю GIT'
############################################################################################################################################
sudo aptitude install git

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
sudo git push

############################################################################################################################################
echo 'Вход в Домен'
############################################################################################################################################
#Вводим в домен
cd /home/$LOGNAME/Загрузки
curl -O http://wiki.astralinux.ru/download/attachments/1998851/astra-winbind_1.7-1_all.deb
curl -O http://wiki.astralinux.ru/download/attachments/1998851/fly-admin-ad_0.1.2_amd64.deb

#sudo ntpdate КОНТРОЛЛЕР_ДОМЕНА














#####################################################################
#На Astra 1.5 не идет:

#PowerShell Core
#Ключ к репозиторию Microsoft
#get -qO - http://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
#Добавляю репозиторий Microsoft
#echo "deb [arch=amd64] http://packages.microsoft.com/repos/microsoft-debian-jessie-prod jessie main" | sudo tee /etc/apt/sources.list.d/microsoft.list

#Steam
#wget http://steamcdn-a.akamaihd.net/client/installer/steam.deb
#sudo aptitude install curl zenity
#sudo dpkg -i steam.deb

#Sublime 3.0
#echo "Добавляю ключ для репозитория SUBLIMETEXT"
#wget -qO - http://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
#echo "Добавляю репозиторий SUBLIMETEXT в /etc/apt/sources.list.d/sublime-text.list"
#echo "deb http://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
