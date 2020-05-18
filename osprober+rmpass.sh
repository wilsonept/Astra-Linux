#!/bin/bash
sudo os-prober
sudo update-grub

PATTERN="/menuentry 'Windows /s/--class os /--class os --unrestricted /1"
sudo sed -i "$PATTERN" /boot/grub/grub.cfg