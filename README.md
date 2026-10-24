# 🌸 Jinx für Debian und Ubuntu

Das apt-Repository für **Jinx** – Discord-Bots in einfachen Worten, auf Deutsch oder Englisch.
Paket **dotjnx**, ab Debian 8 und Ubuntu 14.04, für amd64, arm64, armhf (Raspberry Pi), armel und
i386.

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

Debian 8 und 9 und Ubuntu 14.04 und 16.04 brauchen noch ein paar Handgriffe mehr
(<code>apt-transport-https</code>, bei den ältesten der Schlüssel in <code>/etc/apt/trusted.gpg.d</code>) –
<code>install.sh</code> erledigt das von selbst.

### Entfernen

~~~sh
curl -fsSL https://jinxmrcl.github.io/dotjnx-apt/install.sh | sudo sh -s -- --entfernen
~~~

## English

~~~sh
curl -fsSL https://jinxmrcl.github.io/dotjnx-apt/install.sh | sudo sh                   # once
sudo apt update && sudo apt upgrade                       # every new version
curl -fsSL https://jinxmrcl.github.io/dotjnx-apt/install.sh | sudo sh -s -- --remove    # remove it again
~~~

---

Dieses Repository wird von <code>go run ./tools/apt</code> im Jinx-Quellcode erzeugt – bitte nicht
von Hand ändern. Nach jedem Push installiert ein Workflow das Paket auf Debian 8 bis 13 und
Ubuntu 14.04 bis 26.04, auf amd64, arm64, armhf, armel und i386, und probiert es aus.
