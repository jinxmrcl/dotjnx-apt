#!/bin/sh
# Installs jinx the way the instructions say and tries it out (for apt-install.yml).
set -eu
export DEBIAN_FRONTEND=noninteractive

# Old releases have moved to archive.debian.org or old-releases.ubuntu.com. Only the packages of
# the distribution come from there unchecked; the repository of dotjnx is checked as usual.
archived() {
  . /etc/os-release
  case "$ID" in
  debian)
    codename=${VERSION_CODENAME:-$(echo "$VERSION" | sed -n 's/.*(\([a-z]*\)).*/\1/p')}
    case "$codename" in
    jessie|stretch|buster) security="$codename/updates" ;;
    *) security="$codename-security" ;;
    esac
    rm -f /etc/apt/sources.list.d/*
    {
      echo "deb [trusted=yes] http://archive.debian.org/debian $codename main"
      echo "deb [trusted=yes] http://archive.debian.org/debian-security $security main"
    } > /etc/apt/sources.list ;;
  ubuntu)
    sed -i 's#http://[a-z.]*ubuntu\.com/ubuntu#http://old-releases.ubuntu.com/ubuntu#' /etc/apt/sources.list ;;
  esac
  echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99archiv
}
# a release on its way into the archive may fail at the update or only at the download
curl_from_distribution() {
  apt-get update -qq > /tmp/apt.log 2>&1 &&
    ! grep -q -e 'Failed to fetch' -e '404' -e 'Release file' /tmp/apt.log &&
    apt-get install -y -qq curl > /dev/null 2>> /tmp/apt.log
}
if ! curl_from_distribution; then
  cat /tmp/apt.log
  echo "→ alte Version: Pakete der Distribution aus dem Archiv"
  archived
  apt-get update -qq
  apt-get install -y -qq curl > /dev/null
fi
curl -fsSL https://jinxmrcl.github.io/dotjnx-apt/install.sh | sh

cat /etc/apt/sources.list.d/dotjnx.list
dpkg -s dotjnx | grep -E '^(Version|Architecture):'
jinx version

cd "$(mktemp -d)"
cat > bot.jnx <<'EOF'
bot "Apt-Test" {
  token: geheim("DISCORD_TOKEN")
}

befehl /ping "Antwortet mit Pong" {
  antworte "Pong! 🏓"
}

test "Ping" {
  /ping
  erwarte antwort ist "Pong! 🏓"
}
EOF
jinx check bot.jnx
jinx test bot.jnx

# apt is in charge now: jinx install leaves ~/.local/bin alone
jinx install
test ! -e "$HOME/.local/bin/jinx"

# and everything goes away again
curl -fsSL https://jinxmrcl.github.io/dotjnx-apt/install.sh | sh -s -- --entfernen
test ! -e /usr/bin/jinx
test ! -e /etc/apt/sources.list.d/dotjnx.list
