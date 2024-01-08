#!/bin/bash
#

#Actualización de repositorios
sudo sed -i '1 s/^/#/' /etc/apt/sources.list
# Add Docker's official GPG key:
sudo apt install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-add-repository 'deb http://deb.debian.org/debian/ sid main' -y
wget -O - https://apt.corretto.aws/corretto.key | sudo gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg && \
echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" | sudo tee /etc/apt/sources.list.d/corretto.list

sudo apt-get update -y

#Instalación de Java 8
sudo apt install openjdk-8-jdk -y
apt-add-repository --remove 'deb http://deb.debian.org/debian/ sid main' -y

sudo apt-get update -y

#Instalación de SSH
sudo apt-get install openssh-server openssh-client -y
sed -i 's/\#PermitRootLogin prohibit-password/PermitRootLogin yes/'g /etc/ssh/sshd_config
sed -i 's/\#Port 22/Port 4565/g' /etc/ssh/sshd_config
sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
sudo service sshd restart

#Instalación de librerías
sudo apt install '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev -y

#Instalación de Net tools
sudo apt install net-tools -y

#Instalación de GParted
sudo apt install gparted -y

#Instalación de Docker
VERSION_STRING=5:24.0.7-1~debian.12~bookworm
sudo apt install docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-buildx-plugin docker-compose-plugin -y

#Configuración de ACPI
sudo apt install acpi-support-base -y
sed -i '$ a event=button\[ \/\]power' /etc/acpi/events/powerbtn-acpi-support
sed -i '$ a action=\/etc\/acpi\/powerbtn.sh' /etc/acpi/events/powerbtn-acpi-support
sudo echo -e '#!/bin/bash\n\npoweroff\n\nexit' > /etc/acpi/powerbtn.sh
sudo chmod +x /etc/acpi/powerbtn.sh

#Instalación de Python pip
sudo apt install python3-pip -y
pip3 install pydicom --break-system-packages

#Instalación de UFW
sudo apt install ufw -y
sudo ufw enable && sudo ufw allow 443 && sudo ufw allow 4565 && sudo ufw allow 8843

#Instalación de Fail2Ban
sudo apt install fail2ban -y
sudo cp Fail2ban_ConfigFile /etc/fail2ban/jail.local
sudo systemctl restart fail2ban

#Instalación de rsync
sudo apt install rsync -y

#Instalación de Wireshark
sudo DEBIAN_FRONTEND=noninteractive apt-get -yq install wireshark -y

#Instalación de Bpytop
sudo apt install wget -y
wget https://bootstrap.pypa.io/get-pip.py -O - | python3
pip3 install bpytop --upgrade --break-system-packages

#Instalación de Angry IPscan
wget https://github.com/angryip/ipscan/releases/download/3.5.2/ipscan_3.5.2_amd64.deb -O ipscan.deb
sudo dpkg -i ipscan.deb && sudo rm ipscan.deb

#Instalación de Teamviewer
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo dpkg -i ./teamviewer_amd64.deb && sudo rm teamviewer_amd64.deb
teamviewer --passwd Erillam2023

#Instalación de Dropbox
wget -c https://www.dropbox.com/download?dl=packages/debian/dropbox_2023.09.06_amd64.deb 
sudo apt install libgtk-4-1 -y
sudo apt install libpango1.0-0 -y
sudo apt install gir1.2-gtk-4.0 -y
sudo dpkg -i download?dl=packages%2Fdebian%2Fdropbox_2023.09.06_amd64.deb && sudo rm download?dl=packages%2Fdebian%2Fdropbox_2023.09.06_amd64.deb
#sudo echo -e '#!/bin/bash\n\ndropbox start -i\n\nexit' > /etc/init.d/dropbox
#sudo chmod +x /etc/init.d/dropbox
#sudo update-rc.d dropbox defaults

#Instalación de Weasis
wget https://github.com/nroduit/Weasis/releases/download/v4.2.1/weasis_4.2.1-1_amd64.deb
sudo dpkg -i weasis_4.2.1-1_amd64.deb && sudo rm weasis_4.2.1-1_amd64.deb

#Se agrega el usuario soporte
sudo useradd -m -s /bin/bash soporte
sudo usermod -aG docker soporte
sudo usermod -aG pacs soporte
sudo usermod -aG sudo soporte
sudo chmod 774 /home/pacs

#Instalación de xrdp
sudo apt install xrdp -y
sudo adduser xrdp ssl-cert
sudo systemctl enable --now xrdp
systemctl start xrdp
sudo ufw allow 3389

#Instalación de cpu-x
sudo apt install cpu-x -y

#Instalación de Nemo
sudo apt install nemo -y
sudo apt remove dolphin -y --purge

#Editar el crontab
echo "Editing crontab..."; echo "$(crontab -l)
$*" | crontab - && echo "Crontab edited successfully." || echo "Couldn't edit crontab."