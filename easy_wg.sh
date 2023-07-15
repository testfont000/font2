#!/bin/bash

# Определяем внешний IP-адрес
external_ip=$(curl -s ifconfig.me)

# Выводим результат
echo "Ваш внешний IP-адрес: $external_ip"
echo "Нажмите клавишу Enter для продолжения..."

read

echo "Придумайте пароль:"
read pass


docker run -d \
  --name=wg-easy \
  -e WG_HOST=$external_ip \
  -e PASSWORD=$pass \
  -v ~/.wg-easy:/etc/wireguard \
  -p 51820:51820/udp \
  -p 51821:51821/tcp \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --sysctl="net.ipv4.ip_forward=1" \
  --restart unless-stopped \
  weejewel/wg-easy

echo "Установка завершена. откройте адрес в браузере http://$external_ip:51821"



