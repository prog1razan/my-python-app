#!/bin/bash
set -e

date
echo "Updating Python application on VM..."

APP_DIR="/home/azureuser/my-python-app"
BRANCH="main"

# Allow Git operations when the script runs through Azure Custom Script Extension
sudo git config --global --add safe.directory "$APP_DIR"

# Update code
if [ ! -d "$APP_DIR/.git" ]; then
    echo "Repository not found at $APP_DIR"
    exit 1
fi

sudo -u azureuser bash -c "cd $APP_DIR && git pull origin $BRANCH"

# Install dependencies
sudo -u azureuser "$APP_DIR/venv/bin/pip" install --upgrade pip
sudo -u azureuser "$APP_DIR/venv/bin/pip" install -r "$APP_DIR/requirements.txt"

# Restart the service
sudo systemctl restart myapp

echo "Python application update completed!"
