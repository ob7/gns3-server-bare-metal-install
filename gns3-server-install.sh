#from source
#must install gns3-server and ubridge


#gns-server:
sudo adduser gns3  #add gns3 user that gns3 server will run as
su gns3   # change to gns3 user
cd /home/gns3  #change to gns3 user home directory
sudo apt-get install python3-setuptools python3-pip qemu-kvm qemu-system-x86 mtools git #install OS deps for gns3-server
git clone https://github.com/GNS3/gns3-server  #git clone src
cd gns-server  #cd to src
#This method installs to the user directory.  You should run as user gns3, files will be created in /home/gns3

#gns3@gns3:~/gns3-server$
python3 -m pip install -r requirements.txt  #install python deps

#gns3@gns3:~/gns3-server$
python3 -m pip install .  #install gns3-server itself

#It will put gns3server into .local/bin

#Allow user gns3 to run qemu:
#gns3@gns3:~/gns-server$
sudo usermod -aG kvm gns3 #add gns3 user to run kvm/qemu


#ubridge:
sudo apt install -y libpcap-dev  #required for building ubridge
git clone https://github.com/GNS3/ubridge.git  #clone ubridge src
cd ubridge
make
sudo make install

#create gns3.service at
#/usr/lib/systemd/system/gns3.service

sudo bash -c 'cat > /usr/lib/systemd/system/gns3.service' << EOF
[Unit]
Description=GNS3 server
Wants=network-online.target
After=network.target network-online.target

[Service]
User=gns3
Group=gns3
ExecStart=/home/gns3/.local/bin/gns3server

[Install]
WantedBy=multi-user.target
EOF

echo -e "
start service with
systemctl start gns3.service

autostart at boot with
systemctl enable gns3.service

to see logs run:
journalctrl -u gns3.service -f
"


