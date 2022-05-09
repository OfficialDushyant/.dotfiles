#!/bin/sh

# TODO

# Instal nerd fonts

# Setup Oh-my-zsh

# Add dotfiles with stow (git configs, vim configs, zsh configs)


# Run stow commands to sync dotfiles

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

RESTART_REQUIRED=false
OS="$(uname -s)"

# if [ "$OS" = "Linux" ]; then
#   # Add ASCII art for OS

#   printf "${BLUE}Initiating initial setup for Linux operating system.\n${NC}"
#   printf "${RED}This script is tested for following linux distribution.\n
#   1) Pop!_OS\n
#   2) Ubuntu\n
#   \n${NC}"

#   # Print System info
#   printf "$(egrep '^(VERSION|NAME)=' /etc/os-release)\n\n"
#   # Ask if user want to go ahead with the setup

#   printf "${YELLOW}Would you like to continue with the Linux initial setup ? [Y/n]${NC}\n"
#   continue_default="y" # Set Y to be default value
#   read  continue # Read user input
#   continue="${continue:-${continue_default}}" # Assign default value
#   continue=$(echo $continue | tr '[:upper:]' '[:lower:]')  # Change input to lowercase
#   # If user in put is not "Y" exit the Script
#   if [ "$continue" != "y" ] ; then
#   exit 0
#   fi

#   # Update apt before installing
#   sudo apt update && sudo apt upgrade

#   # Install "TimeShift" backup app
#   printf "${YELLOW}Installing TimeShift application for automated backup snapshot (Similar functionality as Time Machine in MacOS)${NC}\n\n"

#   # Install TimeShift for snapshot backup
#   sudo apt-get install timeshift

#   printf "${YELLOW}Installing Flameshot application for taking Screenshot.${NC}\n\n"
#   # Install Flameshot app for screen shot
#   sudo apt-get install flameshot
#   # Create dir for screenshot if don't exist
#   Screenshots="$HOME/Pictures/Screenshots"
#   if [ ! -d "$Screenshots" ]; then
#     mkdir $Screenshots
#   fi

#   # Install Snap package
#   printf "${YELLOW}Installing Snap package manager.${NC}\n\n"
#   sudo apt-get install snapd

#   # Installing bitwarden
#   printf "${YELLOW}Installing Bitwarden password manager.${NC}\n\n"
#   sudo snap install bitwarden

#   # Installing Authy
#   printf "${YELLOW}Installing 2FA Auth TOTP.${NC}\n\n"
#   sudo snap install authy
#   # Create required directories in system
#   # printf "\n${GREEN}Creating required directories.${NC}\n"

#   # Create default directory for saving Screenshots

#   exit 0
# fi

# Drawing ascii art based on os
draw_ascii() {
  case $1 in
  'Linux')
    printf "\n\n\n$GREEN
                                                                 #####
                                                                #######
                   #                                            ##O#O##
  ######          ###                                           #VVVVV#
    ##             #                                          ##  VVV  ##
    ##         ###    ### ####   ###    ###  ##### #####     #          ##
    ##        #  ##    ###    ##  ##     ##    ##   ##      #            ##
    ##       #   ##    ##     ##  ##     ##      ###        #            ###
    ##          ###    ##     ##  ##     ##      ###       QQ#           ##Q
    ##       # ###     ##     ##  ##     ##     ## ##    QQQQQQ#       #QQQQQQ
    ##      ## ### #   ##     ##  ###   ###    ##   ##   QQQQQQQ#     #QQQQQQQ
  ############  ###   ####   ####   #### ### ##### #####   QQQQQ#######QQQQQ\n\n\n$NC"
    ;;
  *)
    printf "$OS is not supported by this script"
    ;;
  esac
}

system_setup() {
  draw_ascii $OS
  case $OS in
  "Linux")
    . /etc/os-release
    DIST=$NAME
    VER=$VERSION_ID

    # Support WARNING;
    printf "${RED}This script is tested for following linux distribution.\n 
    1) Pop!_OS 18.04 LTS and up\n 
    2) Ubuntu 18.04 LTS and up\n
    \n${NC}"

    # Ask if user want to go ahead with the setup

    printf "${YELLOW}Would you like to continue with the Linux initial setup ? [Y/n]${NC}\n"
    continue_default="y"                                    # Set Y to be default value
    read continue                                           # Read user input
    continue="${continue:-${continue_default}}"             # Assign default value
    continue=$(echo $continue | tr '[:upper:]' '[:lower:]') # Change input to lowercase
    # If user in put is not "Y" exit the Script
    if [ "$continue" != "y" ]; then
      exit 0
    fi

    # Create log file with system info
    LogFile="$HOME/.dotfiles/SYSTEM_INFO.log"

    if [ ! -f "$LogFile" ]; then
      printf "OS Info\n\n$(cat /etc/os-release)\n\n\n" >>SYSTEM_INFO.log
      printf "CPU Info\n\n$(sudo lscpu)\n\n\n" >>SYSTEM_INFO.log
      printf "GPU Info\n\n$(sudo lshw -C display)\n\n\n" >>SYSTEM_INFO.log
      printf "Memory Info\n\n$(sudo lshw -C memory)\n\n\n" >>SYSTEM_INFO.log
      printf "Volume Info\n\n$(sudo lshw -C volume)\n\n\n" >>SYSTEM_INFO.log

      # Set restart to true as it will be first time setup
      RESTART_REQUIRED=true
    fi
    # Update and upgrade default apt packaging system for Debian
    sudo apt update && sudo apt upgrade
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
}

install_package_manager() {
  case $OS in
  "Linux")
    # Snap package manager
    printf "\n $YELLOW_HL Installing snapd package for $DIST $VER. $NC\n"
    sudo apt-get install snapd
    # Flatpak package manager
    printf "\n $YELLOW_HL Installing Flatpak package for $DIST $VER. $NC\n"
    sudo apt-get install flatpak
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    ;;
  *)
    # leave as is
    return
    ;;
  esac
}

install_apps() {
  case $OS in
  "Linux")
    # Install BitWarden (Password manager)
    printf "\n $YELLOW_HL Installing Bitwarden password manager $NC\n"
    sudo sudo snap install bitwarden
    # Install Authy (OTP 2FA generator)
    printf "\n $YELLOW_HL Installing Authy 2FA OTP generator $NC\n"
    sudo snap install authy
    # Install GNU Stow for managing configs using symlinks
    printf "\n $YELLOW_HL Installing GNU Stow for managing dotfiles$NC\n"
    sudo apt-get install stow
    ;;
  *)
    # leave as is
    return
    ;;
  esac

}
install_fonts()
{
  case $OS in
  "Linux")
      cp -r "$(pwd)/fonts/fira_code_nf" "$HOME/.local/share/fonts"
      cp "$(pwd)/fonts/PowerlineSymbols.otf" "$HOME/.local/share/fonts"
      fc-cache -f -v
    ;;
  *)
    # leave as is
    return
    ;;
  esac
}

main() {
  if [ "$(pwd)" != "$HOME/.dotfiles" ]; then
    echo "You'll need to clone .dotfiles in your home folder to make it work."
    exit 0
  fi
  # Performs initial setup for new systems (Installing basic packages)
  system_setup

  # Add Package managers
  install_package_manager

  # Install basic applications
  install_apps

  # Install Fonts
  install_fonts

  # Reboot system 
  if [ "$RESTART_REQUIRED" = true ]; then
    printf "${RED}System will require to reboot after upgrade, You need to run this script again once the system reboots; would you like to reboot now? [Y/n]${NC}\n"
    reboot_default="y"                                    # Set Y to be default value
    read reboot                                           # Read user input
    reboot="${reboot:-${reboot_default}}"                 # Assign default value
    reboot=$(echo $reboot | tr '[:upper:]' '[:lower:]')   # Change input to lowercase
    # If user in put is not "Y" exit the Script
    if [ "$reboot" = "y" ]; then
        case $OS in
        "Linux")
          sudo systemctl reboot
        ;;
        "Darwin")
          sudo shutdown -r now
        ;;
        *)
          # leave as is
        return
        ;;
  esac
    else
      printf "${RED}You will require to do manual reboot for some updates to take effect.${NC}\n"
      sleep 5
    fi
  fi

  exit 0
}

main
