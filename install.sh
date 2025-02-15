#!/bin/bash

INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="header"

# Download the header.sh script from GitHub and save it as 'header'
curl -o "$INSTALL_DIR/$SCRIPT_NAME" "https://raw.githubusercontent.com/KMean/header-maker/master/bin/header.sh" || {
  echo "Error downloading the script."
  exit 1
}

# Make it executable
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

echo "Installation complete! Use 'header --py \"YOUR AWESOME HEADER\"' to generate headers."
echo "For more information, visit https://github.com/KMean/header-maker."