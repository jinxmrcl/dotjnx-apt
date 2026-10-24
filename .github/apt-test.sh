#!/bin/sh
# Installs jinx the way the instructions say and tries it out (for apt-install.yml).
set -eu
export DEBIAN_FRONTEND=noninteractive

apt-get update -qq
apt-get install -y -qq curl > /dev/null
curl -fsSL https://jinxmrcl.github.io/dotjnx-apt/install.sh | sh

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
