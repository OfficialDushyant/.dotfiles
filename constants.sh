#!/bin/sh

# Color Code
WHITE='\033[0;37m'
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
# SET OS,Distribution, version and custom constants
case $OS in
  "Linux")
    . /etc/os-release
    DIST=$NAME
    VER=$VERSION_ID
    ;;
  "Darwin")

    ;;
  *)
    # leave as is
    return
    ;;
  esac