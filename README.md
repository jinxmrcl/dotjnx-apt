# 🌸 Jinx für Debian und Ubuntu

Das apt-Repository für **Jinx** – Discord-Bots in einfachen Worten, auf Deutsch oder Englisch.
Paket **dotjnx**, für amd64, arm64 und armhf (Raspberry Pi).

## Installieren

~~~sh
curl -fsSL https://jinxmrcl.github.io/dotjnx-apt/install.sh | sudo sh
~~~

Das fügt die Paketquelle einmal hinzu und installiert <code>jinx</code>. Neue Versionen kommen
danach ganz normal:

~~~sh
sudo apt update && sudo apt upgrade
~~~

### Von Hand

~~~sh
sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://jinxmrcl.github.io/dotjnx-apt/dotjnx.gpg | sudo tee /etc/apt/keyrings/dotjnx.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/dotjnx.gpg] https://jinxmrcl.github.io/dotjnx-apt stable main" | sudo tee /etc/apt/sources.list.d/dotjnx.list
sudo apt update
sudo apt install dotjnx
~~~

Fingerabdruck des Signaturschlüssels: <code>9712 1206 6447 89EA 14DC D0FC E9A7 EDF3 9AA0 1C7B</code>

### Entfernen

~~~sh
sudo apt remove dotjnx
sudo rm /etc/apt/sources.list.d/dotjnx.list /etc/apt/keyrings/dotjnx.gpg
~~~

## English

~~~sh
curl -fsSL https://jinxmrcl.github.io/dotjnx-apt/install.sh | sudo sh    # once
sudo apt update && sudo apt upgrade        # every new version
~~~

---

Dieses Repository wird von <code>go run ./tools/apt</code> im Jinx-Quellcode erzeugt – bitte nicht
von Hand ändern. Nach jedem Push installiert ein Workflow das Paket auf Debian 12 und 13 und
Ubuntu 22.04, 24.04 und 26.04 und probiert es aus.
