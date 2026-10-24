#!/bin/sh
# Jinx für Debian und Ubuntu: fügt das apt-Repository hinzu und installiert das Paket dotjnx.
# Danach kommen neue Versionen mit „sudo apt upgrade“.
#
#   curl -fsSL https://jinxmrcl.github.io/dotjnx-apt/install.sh | sudo sh
set -eu

URL="https://jinxmrcl.github.io/dotjnx-apt"
KEY=/etc/apt/keyrings/dotjnx.gpg
LIST=/etc/apt/sources.list.d/dotjnx.list

stop() { printf '%s\n' "$*" >&2; exit 1; }

[ "$(id -u)" -eq 0 ] || stop "Bitte mit sudo starten / please run it with sudo:
  curl -fsSL $URL/install.sh | sudo sh"
command -v apt-get >/dev/null 2>&1 || stop "Das ist für Debian und Ubuntu (apt) / this is for Debian and Ubuntu (apt)."

fetch() {
  if command -v curl >/dev/null 2>&1; then curl -fsSL "$1"
  elif command -v wget >/dev/null 2>&1; then wget -qO- "$1"
  else stop "curl oder wget fehlt / curl or wget is missing"
  fi
}

if [ ! -e /etc/ssl/certs/ca-certificates.crt ]; then
  apt-get update -qq
  apt-get install -y -qq ca-certificates
fi
install -d -m 0755 /etc/apt/keyrings
fetch "$URL/dotjnx.gpg" > "$KEY.neu"
mv "$KEY.neu" "$KEY"
chmod 0644 "$KEY"
echo "deb [signed-by=$KEY] $URL stable main" > "$LIST"

# nur diese Quelle lesen: schneller, und kaputte andere Quellen stören nicht
apt-get update -qq -o Dir::Etc::sourcelist="$LIST" -o Dir::Etc::sourceparts=- -o APT::Get::List-Cleanup=0
apt-get install -y dotjnx

echo
echo "✓ Jinx $(jinx version) ist installiert / is installed"
echo "  • Updates: sudo apt update && sudo apt upgrade"
echo "  • Loslegen / get started: jinx new meinbot"
