#!/bin/bash
INSTALLER_DIR="$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")"
USER=$(whoami)

echo "Update package data"
sudo apt-get update
sudo systemctl disable Klipperscreen
sudo systemctl mask ModemManager.service

sudo apt install chromium unclutter xdotool -y

SERVICE_PRE_EXEC=$(<$INSTALLER_DIR/resources/chromium_service_pre_exec.sh)
SERVICE_PRE_EXEC=$(sed "s/USER/$USER/g" <<< $SERVICE_PRE_EXEC)
SERVICE_PRE_EXEC=$(sed "s/CHROMIUM_URL/$CHROMIUM_URL/g" <<< $SERVICE_PRE_EXEC)
echo "$SERVICE_PRE_EXEC" | sudo tee /usr/local/lib/chromium_service_pre_exec.sh > /dev/null
sudo chown root:root /usr/local/lib/chromium_service_pre_exec.sh
sudo chmod 644 /usr/local/lib/chromium_service_pre_exec.sh


SERVICE=$(<$INSTALLER_DIR/resources/chromium.service)
SERVICE=$(sed "s/USER/$USER/g" <<< $SERVICE)

echo "$SERVICE" | sudo tee /etc/systemd/system/chromium.service > /dev/null
sudo systemctl unmask chromium.service
sudo systemctl daemon-reload
sudo systemctl enable chromium



