#!/bin/sh

# Color Code
RED='\033[0;31m'
RED_HL='\033[1;41m'
GREEN_HL='\033[1;42m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BLUE_HL='\033[1;44m'
YELLOW='\033[0;33m'
YELLOW_HL='\033[1;43m'
NC='\033[0m' # No Color

# Timestamp
TIME=$(date "+%Y.%m.%d-%H.%M.%S")

# OS type
OS="$(uname -s)"

# Local dotfiles path 
DOTFILES_CONF="$HOME/.dotfiles/configs"

# Get OS Distribution and version
case $OS in
  "Linux")
    . /etc/os-release
    DIST=$NAME
    VER=$VERSION_ID
    ;;
  "Darwin")
    OIFS="$IFS"
    IFS=$'\n'
    set $(sw_vers) >/dev/null
    DIST=$(echo $1 | tr "\n:\t\t\t" ' ' | sed 's/ProductName[ ]*//')
    VER=$(echo $2 | tr "\n:\t\t" ' ' | sed 's/ProductVersion[ ]*//')
    ;;
  *)
    # leave as is
    return
    ;;
  esac