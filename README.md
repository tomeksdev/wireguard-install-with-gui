# Wireguard server GUI install script

## About
Purpose of this script is to easier install of wireguard server together with management gui for wireguard. GUI is taken from this repository and I was writen a little script to install on linux server machines.

## Instructions
To download this script, click [THIS LINK](https://github.com/tomeksdev/wireguard-install-with-gui/releases/download/v1.0.1/WG-Server-Install.tar.gz) or follow the commands below.

### Command install
To download it from the server, if you did not download it from the browser, you must enter the following command.

``` 
wget https://github.com/tomeksdev/wireguard-install-with-gui/releases/download/v1.0.0/WG-Server-Install.tar.gz
```
OR

```
git clone https://github.com/tomeksdev/wireguard-install-with-gui.git
```

If you downloaded from a browser or with the ``wget`` command, you need to unpack the downloaded file with the following command. If you are working with git, you can skip this step.

```
tar -xvf WG-Server-Install.tar.gz
```

Once the file is unzipped or cloned with Git, we only need to do two things to make the script work. First, we need to add an executable right to the `wg-server-install.sh`` file, which we can then run.

```
chmod +x wg-server-install.sh
```

Only what is left to follow instructions from installation.

### Screenshots

![Alt](https://vujca.github.io/postImages/wireguard/continue.png "Continue")
![Alt](https://vujca.github.io/postImages/wireguard/IPv4-IPv6.png "IPv4/IPv6")
![Alt](https://vujca.github.io/postImages/wireguard/default-port.png "Default Port")
![Alt](https://vujca.github.io/postImages/wireguard/finished.png "Finish")
![Alt](https://vujca.github.io/postImages/wireguard/server-settings.png "Server Settings")
![Alt](https://vujca.github.io/postImages/wireguard/global-settings.png "Global Settings")
![Alt](https://vujca.github.io/postImages/wireguard/new-client.png "New Client")
![Alt](https://vujca.github.io/postImages/wireguard/created-client.png "Created Client")

## Vesrions

#### New version v1.0.1
[![GitHub Release](https://img.shields.io/github/v/release/tomeksdev/wireguard-install-with-gui?color=%2332CD32)](https://github.com/tomeksdev/wireguard-install-with-gui/releases/tag/v1.0.1)
- fix on installation because of new versions of Wireguard GUI

------------------------------------------------------

#### Old version v1.0.0
[![GitHub release](https://img.shields.io/badge/release-v1.0.0-darkred)](https://github.com/tomeksdev/wireguard-install-with-gui/releases/tag/v1.0.0)
- install wireguard, curl and tar packages
- prepare all config files, services and scripts for wireguard GUI
- add executable rights
- enable services and start automatically