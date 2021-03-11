### правим загрузчик
```bash
sudo vim /boot/grub/grub.cfg
```
Для того что бы винда грузилась без запроса пароля необходимо добавить *--unrestricted* в строку *menuentry 'Windows 7'*
Пример:
```text
menuentry 'Windows 7 (на /dev/sda1)' --class windows --class os $menuentry_id_option 'osprober-chain-D670298370296C05' {
```
#### устанавливаем загрузку винды по умолчанию
необходимо скопировать id строки загрузки (в нашем случаем строки *menuentry 'Windows 7'*) <br />
Пример:
```text
osprober-chain-D670298370296C05
```
вставляем в *set default* который записан ниже else <br />
Пример:
```text
if [ "${next_entry}" ] ; then
   set default="${next_entry}"
   set next_entry=
   save_env next_entry
   set boot_once=true
else
   set default="СЮДА"
fi

# должно получиться так:
if [ "${next_entry}" ] ; then
   set default="${next_entry}"
   set next_entry=
   save_env next_entry
   set boot_once=true
else
   set default="osprober-chain-D670298370296C05"
fi
```
### Качаем обновления (Бюллетень)
astralinux.ru

после скачивания обновления необходимо добавить строку в /etc/apt/sources.list

```text
deb file:///mnt smolensk main contrib non-free
```
после этого необходим смонтировать скачанный .iso файл в папку mnt
```bash
sudo mount -o loop /home/ib/Загрузки/20200722SE16.iso /mnt
```
далее можно обновляться
```bash
sudo apt update
sudo apt -y distr-upgrade
```
### Установка касперского
```bash
# создаем папку /KLUpdates
sudo mkdir /KLUpdates
# запускаем установку каспера
sudo dpkg -i /home/ib/Загрузки/kesl-astra_11.1.0-3013_amd64.deb
# подключаем флешку с обновлениями и примонтируем ее
# теперь примонтируем папку с обновлениями в папку /KLUpdates
sudo mount -B /<путь к базам касперского на флешке> /KLUpdates
# копируем ключ касперского 
sudo cp /<путь к файлу ключа на флешке> /tmp/key.key
# затем потребуется запустить скрипт настройки каспера
sudo /opt/kaspersky/kesl/bin/kesl-setup.pl
```
```text
enter
y enter
G enter
y enter
y enter
y enter
y enter
ib enter
/KLUpdate enter (если интернет есть то просто жмем enter)
y enter
n enter
n enter
/tmp/key.key
```
