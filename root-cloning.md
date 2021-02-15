### делаем раздел ext4 и swap
```bash
fdisk -l # смотрим какие диски нам доступны
fdisk /dev/sda # переходим в редактирование партиций
```
> **m** отображает справку <br />
> делаем основной раздел <br />
> **n**\<enter\> **p**\<enter\> (default)\<enter\> (указываем секторы до начала свапа)\<enter\> <br />
> делаем swap раздел <br />
> **n**<\enter\> **p**\<enter\> (default)\<enter\> (default)\<enter\> <br />
> меняем тип раздела на swap <br />
> **t**\<enter\> **82**\<enter\> <br />

### форматируем основной раздел в ext4
```bash
mkfs.ext4 /dev/sda3
```

### монтируем файловую систему
```bash
mount /dev/sda3 /mnt
```
### копируем архив в /mnt и распаковываем его
```bash
cp /media/backup.tar.gz /mnt
cd /mnt
tar -xzf backup.tar.gz
```
### создаем необходимые каталоги
```bash
cd /mnt
mkdir {dev,proc,sys,run,media}
mkdir /media/{floppy0,cdrom0}
ln -s /media/floppy0 floppy # чек
ln -s /media/cdrom0 cdrom # чек
```

### монтируем в эти каталоги нынешние dev,proc,sys
```bash
mount --rbind /dev /mnt/dev
mount --rbind /proc /mnt/proc
mount --rbind /sys /mnt/sys
```

### проваливаемся в новую систему с оболочкой bash
```bash
chroot /mnt bash
```
### устанавливаем grub
```bash
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
update-grub
```

### далее необходимо добавить правильные UUID в fstab
(lsblk --output UUID /dev/sdaX или blkid)
```bash
blkid
```
### если UUID для swap отсутствует - форматируем раздел свапа
```bash
mkswap /dev/sda4
```

### добавляем строки с UUID в fstab для дальнейшего редактирования
```bash
lsblk --output UUID /dev/sda3 | tee -a /etc/fstab # для ext4
lsblk --output UUID /dev/sda4 | tee -a /etc/fstab # для swap
```

### заменяем старые UUID на новые которые добавили в конец файла, после замены удаляем последние строки которые добавили предыдущими командами.
```bash
vi /etc/fstab
```

### далее необходимо заменить UUID в /etc/initramfs-tools/conf.d/resume
```bash
lsblk --output UUID /dev/sda4 | tee -a /etc/initramfs-tools/conf.d/resume
vi /etc/initramfs-tools/conf.d/resume
```

### после того как все отредактировано перегенерим initramfs 
```bash
update-initramfs -u

exit
umount -a
shutdown -r now
```
