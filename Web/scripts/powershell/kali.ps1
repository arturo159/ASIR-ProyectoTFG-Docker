$exists = docker ps -a --format "{{.Names}}" | Select-String "^__VM_NAME__$"
echo "Hola soy Jose, gracias por usar nuestro script"
if (-not $exists) {
docker run -dit -p 6080:6080 --name __VM_NAME__ kalilinux/kali-rolling bash

docker exec __VM_NAME__ bash -c "
apt update &&
apt install -y kali-desktop-xfce tightvncserver novnc websockify dbus-x11 xfce4 xfce4-goodies &&
mkdir -p ~/.vnc &&
echo kali | vncpasswd -f > ~/.vnc/passwd &&
chmod 600 ~/.vnc/passwd &&
printf '#!/bin/bash\nxrdb \$HOME/.Xresources\nstartxfce4 &' > ~/.vnc/xstartup &&
chmod +x ~/.vnc/xstartup
"

}

docker start __VM_NAME__ | Out-Null

docker exec __VM_NAME__ bash -c "
export USER=root
pkill Xtightvnc 2>/dev/null
pkill websockify 2>/dev/null
vncserver -kill :1 2>/dev/null
rm -rf /tmp/.X1-lock
rm -rf /tmp/.X11-unix/X1
vncserver :1 -geometry 1280x800 -depth 24
nohup websockify --web=/usr/share/novnc/ 6080 localhost:5901 > /dev/null 2>&1 &
"

Start-Sleep -Seconds 3
Start-Process "http://localhost:6080/vnc_auto.html"