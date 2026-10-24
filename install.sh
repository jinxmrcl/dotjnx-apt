#!/bin/sh
# Jinx für Debian und Ubuntu: fügt das apt-Repository hinzu und installiert das Paket dotjnx.
# Danach kommen neue Versionen mit „sudo apt upgrade“. Geht ab Debian 8 und Ubuntu 14.04.
#
#   curl -fsSL https://jinxmrcl.github.io/dotjnx-apt/install.sh | sudo sh                     installieren
#   curl -fsSL https://jinxmrcl.github.io/dotjnx-apt/install.sh | sudo sh -s -- --entfernen   wieder entfernen
set -eu

URL="https://jinxmrcl.github.io/dotjnx-apt"
LIST=/etc/apt/sources.list.d/dotjnx.list
KEYRING=/etc/apt/keyrings/dotjnx.gpg
TRUSTED=/etc/apt/trusted.gpg.d/dotjnx.gpg

stop() { printf '%s\n' "$*" >&2; exit 1; }

[ "$(id -u)" -eq 0 ] || stop "Bitte mit sudo starten / please run it with sudo:
  curl -fsSL $URL/install.sh | sudo sh"
command -v apt-get >/dev/null 2>&1 || stop "Das ist für Debian und Ubuntu (apt) / this is for Debian and Ubuntu (apt)."

case "${1:-}" in
--entfernen|--remove)
  apt-get remove -y dotjnx || true
  rm -f "$LIST" "$KEYRING" "$TRUSTED"
  echo "✓ Jinx und seine Paketquelle sind entfernt / Jinx and its package source are removed"
  exit 0 ;;
esac

fetch() {
  if command -v curl >/dev/null 2>&1; then curl -fsSL "$1"
  elif command -v wget >/dev/null 2>&1; then wget -qO- "$1"
  else stop "curl oder wget fehlt / curl or wget is missing"
  fi
}

# apt vor 1.5 (Debian 9, Ubuntu 16.04 und älter) liest https-Quellen erst mit apt-transport-https
need=""
[ -e /etc/ssl/certs/ca-certificates.crt ] || need="ca-certificates"
[ -e /usr/lib/apt/methods/https ] || need="$need apt-transport-https"
if [ -n "$need" ]; then
  apt-get update -qq || true
  apt-get install -y -qq $need
fi

# Ab apt 1.1 gilt der Schlüssel nur für diese Quelle (signed-by). Debian 8 und Ubuntu 14.04
# kennen das noch nicht – dort vertraut apt ihm wie den Schlüsseln der Distribution.
if dpkg --compare-versions "$(dpkg-query -W -f='${Version}' apt)" ge 1.1; then
  KEY=$KEYRING
  LINE="deb [signed-by=$KEY] $URL stable main"
else
  KEY=$TRUSTED
  LINE="deb $URL stable main"
fi
install -d -m 0755 "$(dirname "$KEY")"
fetch "$URL/dotjnx.gpg" > "$KEY.neu"
mv "$KEY.neu" "$KEY"
chmod 0644 "$KEY"
echo "$LINE" > "$LIST"

# nur diese Quelle lesen: schneller, und kaputte andere Quellen stören nicht
apt-get update -qq -o Dir::Etc::sourcelist="$LIST" -o Dir::Etc::sourceparts=- -o APT::Get::List-Cleanup=0
apt-get install -y dotjnx

echo
echo "✓ Jinx $(jinx version) ist installiert / is installed"
echo "  • Updates: sudo apt update && sudo apt upgrade"
echo "  • Loslegen / get started: jinx new meinbot"
