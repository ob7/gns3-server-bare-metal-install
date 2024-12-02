# gns3-server-bare-metal-install

This repository provides a guide and script for installing the GNS3 server and Ubridge on a bare metal server. It ensures proper setup of dependencies, installation from source, and configuration for running the GNS3 server as a service.

---

## Installation Steps

### From Source
The following steps install the GNS3 server and Ubridge from source and set them up as a service.

### GNS3 Server Installation

#### Add the `gns3` User

```
sudo adduser gns3  # Add the gns3 user that the GNS3 server will run as  
su gns3            # Switch to the gns3 user  
cd /home/gns3      # Change to the gns3 user home directory  
```

#### Install OS Dependencies

```
sudo apt-get install python3-setuptools python3-pip qemu-kvm qemu-system-x86 mtools git  
```

#### Clone the GNS3 Server Repository

```
git clone https://github.com/GNS3/gns3-server  
cd gns3-server  
```

#### Install Python Dependencies

```
python3 -m pip install -r requirements.txt  
```

#### Install the GNS3 Server

```
python3 -m pip install .  
```

This installs the `gns3server` binary in `/home/gns3/.local/bin`.

#### Add the `gns3` User to the KVM Group

```
sudo usermod -aG kvm gns3  
```

---

### Ubridge Installation

#### Install OS Dependencies

```
sudo apt install -y libpcap-dev  
```

#### Clone and Build Ubridge

```
cd ~
git clone https://github.com/GNS3/ubridge.git  
cd ubridge  
make  
sudo make install  
```

---

### Configure GNS3 Server as a Service

#### Create the Service File

```
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
```

---

### Start and Check the Service

```
sudo systemctl start gns3.service  
```

To enable it on boot:
```
sudo systemctl enable gns3.service  
```

To check logs:
```
journalctl -u gns3.service -f  
```

---

## Full Script: `gns3-server-install.sh`

```
#!/usr/bin/env bash

# Add gns3 user
sudo adduser gns3  # Add the gns3 user that the GNS3 server will run as
su gns3            # Switch to the gns3 user
cd /home/gns3      # Change to the gns3 user home directory

# Install OS dependencies for GNS3 server
sudo apt-get install python3-setuptools python3-pip qemu-kvm qemu-system-x86 mtools git

# Clone and install GNS3 server
git clone https://github.com/GNS3/gns3-server
cd gns3-server
python3 -m pip install -r requirements.txt
python3 -m pip install .

# Add gns3 user to KVM group
sudo usermod -aG kvm gns3

# Install Ubridge
sudo apt install -y libpcap-dev
git clone https://github.com/GNS3/ubridge.git
cd ubridge
make
sudo make install

# Create GNS3 server service file
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

# Reload systemd, start service, and enable it on boot
sudo systemctl start gns3.service
sudo systemctl enable gns3.service
```
to see logs, run:
journalctl -u gns3.service -f

