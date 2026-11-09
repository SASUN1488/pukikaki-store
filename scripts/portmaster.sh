#!/bin/bash
# PortMaster: каталог портов игр для ARM-приставок (бета: интеграция с оболочкой ещё дорабатывается)
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
mkdir -p "$APPDIR" && unzip -q -o /tmp/PortMaster.zip -d "$APPDIR" && rm /tmp/PortMaster.zip
cat > "$APPDIR/run.sh" <<'RUN'
#!/bin/sh
cd /mnt/sdcard/nk/apps/portmaster/PortMaster && exec ./PortMaster.sh
RUN
chmod +x "$APPDIR/run.sh"
