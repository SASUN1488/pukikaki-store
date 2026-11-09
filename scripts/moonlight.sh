#!/bin/bash
# Moonlight Embedded: стриминг игр с ПК (Sunshine / GeForce Experience). Собирается из исходников.
# Вызывает nkstore: APPDIR=/mnt/sdcard/nk/apps/moonlight bash moonlight.sh install
set -e
p() { echo "@P $1 $2"; }
[ "$1" = install ] || exit 0
p 5 "Ставлю инструменты сборки…"
DEBIAN_FRONTEND=noninteractive apt-get -y install git cmake gcc g++ make pkg-config libopus-dev libexpat1-dev libssl-dev \
  libasound2-dev libudev-dev libavahi-client-dev libcurl4-openssl-dev libevdev-dev libenet-dev libavcodec-dev \
  libsdl2-dev uuid-dev >>/tmp/nkstore.log 2>&1
p 35 "Скачиваю Moonlight…"
rm -rf /tmp/moonlight-src && git clone -q --depth 1 --recursive https://github.com/moonlight-stream/moonlight-embedded.git /tmp/moonlight-src
p 45 "Собираю (около 10 минут)…"
mkdir -p /tmp/moonlight-src/build && cd /tmp/moonlight-src/build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$APPDIR" .. >>/tmp/nkstore.log 2>&1
make -j4 >>/tmp/nkstore.log 2>&1
p 90 "Устанавливаю…"
make install >>/tmp/nkstore.log 2>&1
cat > "$APPDIR/run.sh" <<'RUN'
#!/bin/sh
# первый запуск: сопряжение с ПК (адрес — в /mnt/sdcard/nk/apps/moonlight/host.txt), дальше — стрим Steam
D=/mnt/sdcard/nk/apps/moonlight
HOST=$(cat $D/host.txt 2>/dev/null)
[ -n "$HOST" ] || { echo "Впиши адрес ПК в $D/host.txt"; sleep 5; exit 1; }
export LD_LIBRARY_PATH=$D/lib:$LD_LIBRARY_PATH
[ -e $D/paired ] || { $D/bin/moonlight pair "$HOST" && touch $D/paired; }
exec $D/bin/moonlight stream -app Steam -720 -fps 60 "$HOST"
RUN
chmod +x "$APPDIR/run.sh"
rm -rf /tmp/moonlight-src
