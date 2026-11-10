#!/bin/bash
# PortMaster: каталог портов игр для ARM-приставок. Ставится в /roms/ports (в образе Debian), окно — через gl4es.
# Установленные порты оболочка показывает обложками в «Играх» (читает /roms/ports/*/port.json).
set -e
p() { echo "@P $1 $2"; }
[ "$1" = install ] || exit 0
p 5 "Ставлю зависимости…"
DEBIAN_FRONTEND=noninteractive apt-get -y install unzip python3 python3-sdl2 libsdl2-2.0-0 libsdl2-ttf-2.0-0 libsdl2-image-2.0-0 \
  libsdl2-mixer-2.0-0 >>/tmp/nkstore.log 2>&1
p 40 "Скачиваю PortMaster…"
URL=$(curl -fsSL https://api.github.com/repos/PortsMaster/PortMaster-GUI/releases/latest | grep -o '"browser_download_url": *"[^"]*PortMaster.zip"' | cut -d'"' -f4)
curl -fsSL -o /tmp/PortMaster.zip "$URL"
p 80 "Распаковываю…"
# порты — внутри образа Debian (ext4): на карте exFAT нет символьных ссылок и прав, а порты ими пользуются
mkdir -p /roms/ports && unzip -q -o /tmp/PortMaster.zip -d /roms/ports && rm /tmp/PortMaster.zip
mkdir -p "$APPDIR"
