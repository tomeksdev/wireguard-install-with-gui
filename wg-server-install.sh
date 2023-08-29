#!/bin/bash
echo "Script by TomeksDEV (by Vujca)!"

PURPLE='\033[0;35m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${PURPLE} _    _  _                                             _ "
echo -e "${PURPLE}| |  | |(_)                                           | |"
echo -e "${PURPLE}| |  | | _  _ __   ___   __ _  _   _   __ _  _ __   __| |"
echo -e "${PURPLE}| |/\| || || '__| / _ \ / _' || | | | / _' || '__| / _' |"
echo -e "${PURPLE}\  /\  /| || |   |  __/| (_| || |_| || (_| || |   | (_| |"
echo -e "${PURPLE} \/  \/ |_||_|    \___| \__, | \__,_| \__,_||_|    \__,_|"
echo -e "${PURPLE}                         __/ |                           "
echo -e "${PURPLE}                        |___/                            "
echo ""
echo -e "${GREEN}          _____  _   _  _____ ${CYAN}  _____                     "
echo -e "${GREEN}         |  __ \| | | ||_   _|${CYAN} /  ___|                    "
echo -e "${GREEN}         | |  \/| | | |  | |  ${CYAN} \ '--.  _ __ __   __       "
echo -e "${GREEN}         | | __ | | | |  | |  ${CYAN}  '--. \| '__|\ \ / /       "
echo -e "${GREEN}         | |_\ \| |_| | _| |_ ${CYAN} /\__/ /| |    \ V /        "
echo -e "${GREEN}          \____/ \___/  \___/ ${CYAN} \____/ |_|     \_/         "
echo -e "${NC}      Install script for wireguard server with GUI.\n"

#Continue or not
read -p $'Do you want to continue? (default \e[32myes \e[0m(no/yes)): ' cont
if [ -z "$cont" ]
then
#Install wireguard, curl and tar
apt update && apt install -y wireguard curl tar

#IPv4
read -p $'Enable IPv4(default \e[32myes \e[0m(no/yes)): ' ipv4
if [ -z "$ipv4" ]
then
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
else
echo "net.ipv4.ip_forward=0" >> /etc/sysctl.conf
fi

#IPv6
read -p $'Enable IPv6(default \e[32myes \e[0m(no/yes)): ' ipv6
if [ -z "$ipv6" ]
then
echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
else
echo "net.ipv6.conf.all.forwarding=0" >> /etc/sysctl.conf
fi

#Apply IPv4 and IPv6
sysctl -p

# Enter port for wireguard (default 5000)
read -p $'Enter wireguard web port(Press enter for default \e[32m5000\e[0m): ' port
# Create start-wgui.sh script which use Systemd Service Unit (item 5) to start database and Wireguard-UI
if [ -z "$port" ]
then
echo -e "Create ${GREEN}start.wgui.sh${NC} with default port..."
cat <<EOF > /etc/wireguard/start-wgui.sh
#!/bin/bash
cd /etc/wireguard
./wireguard-ui -bind-address 0.0.0.0:5000
EOF
else
echo -e "Create ${GREEN}start.wgui.sh${NC} with ${port} port..."
cat <<EOF > /etc/wireguard/start-wgui.sh
#!/bin/bash
cd /etc/wireguard
./wireguard-ui -bind-address 0.0.0.0:$port
EOF
fi

# Add execute rights
echo -e "Add execute rights to ${GREEN}start-wgui.sh${NC}..."
chmod +x /etc/wireguard/start-wgui.sh

# Create Systemd service unit for wireguard-gui
echo -e "Create ${GREEN}wgui-web.service${NC}..."
cat <<EOF > /etc/systemd/system/wgui-web.service
[Unit]
Description=WireGuard UI
 
[Service]
Type=simple
ExecStart=/etc/wireguard/start-wgui.sh
 
[Install]
WantedBy=multi-user.target
EOF

# Create Wireguard-UI install and update script always latest version
echo -e "Create ${GREEN}update.sh${NC}..."
cat <<EOF > /etc/wireguard/update.sh
#!/bin/bash
 
VER=\$(curl -sI https://github.com/ngoduykhanh/wireguard-ui/releases/latest | grep "location:" | cut -d "/" -f8 | tr -d '\r')
 
echo "downloading wireguard-ui \$VER"
curl -sL "https://github.com/ngoduykhanh/wireguard-ui/releases/download/\$VER/wireguard-ui-\$VER-linux-amd64.tar.gz" -o wireguard-ui-\$VER-linux-amd64.tar.gz
 
echo -n "extracting "; tar xvf wireguard-ui-\$VER-linux-amd64.tar.gz
 
echo "restarting wgui-web.service"
systemctl restart wgui-web.service
EOF

# Make update.sh script executable and run script
echo -e "Add execute rights to ${GREEN}start-wgui.sh${NC}..."
chmod +x /etc/wireguard/update.sh
echo -e "Run ${GREEN}update.sh..."
cd /etc/wireguard; ./update.sh

# Make wgui.service
echo -e "Create ${GREEN}wgui.service${NC}..."
cat <<EOF > /etc/systemd/system/wgui.service
[Unit]
Description=Restart WireGuard
After=network.target
 
[Service]
Type=oneshot
ExecStart=/bin/systemctl restart wg-quick@wg0.service
 
[Install]
RequiredBy=wgui.path
EOF

# Make wgui.path
echo -e "Create ${GREEN}wgui.path${NC}..."
cat <<EOF > /etc/systemd/system/wgui.path
[Unit]
Description=Watch /etc/wireguard/wg0.conf for changes
 
[Path]
PathModified=/etc/wireguard/wg0.conf
 
[Install]
WantedBy=multi-user.target
EOF

# Make wg0.conf file for wireguardinterface
# Enable wireguard services and start them
echo -e "Create ${GREEN}wg0.conf${NC}..."
touch /etc/wireguard/wg0.conf
echo -e "Enable and starting services..."
systemctl enable wgui.{path,service} wg-quick@wg0.service wgui-web.service
systemctl start wgui.{path,service}
else
exit
fi