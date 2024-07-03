sudo mv /tmp/script.sh /opt/bootscript.sh
sudo mv /tmp/setup_boot.service /usr/lib/systemd/system/setup_boot.service
sudo systemctl enable setup_boot.service