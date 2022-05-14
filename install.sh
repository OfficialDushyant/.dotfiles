#!/bin/sh

# TODO

# Instal nerd fonts

# Setup Oh-my-zsh

# Add dotfiles with stow (git configs, vim configs, zsh configs)

# Run stow commands to sync dotfiles

# use dconf load to load the gnome terminal for linux 

# try to do export and import of terminal profile in mac.

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

# Constants 
RESTART_REQUIRED=false
OS="$(uname -s)"

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
    printf "${BLUE}This script is tested for following linux distribution.\n 
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

install_tools() {
  case $OS in
  "Linux")
    # Install BitWarden (Password manager)
    printf "\n $YELLOW_HL Installing Bitwarden password manager $NC\n"
    sudo sudo snap install bitwarden
    # Install Authy (OTP 2FA generator)
    printf "\n $YELLOW_HL Installing Authy 2FA OTP generator $NC\n"
    sudo snap install authy
    # Install curl
    printf "\n $YELLOW_HL Installing curl HTTP and FTP services$NC\n"
    sudo apt-get install curl
    # Install wget
    printf "\n $YELLOW_HL Installing wget HTTP and FTP services$NC\n"
    sudo apt-get install wget
    # Install exa color schema
    sudo apt-get install exa
    # Install GNU Stow for managing configs using symlinks
    printf "\n $YELLOW_HL Installing GNU Stow for managing dotfiles$NC\n"
    sudo apt-get install stow
    # Install dnf and runtime uuid 
    sudo apt-get install dconf-cli uuid-runtime
    # Install OpenVPN Client 
    sudo apt-get install openvpn
    sudo apt-get install network-manager-openvpn # Need to install the network-manager-openvpn package to make VPN settings from the graphical interface
    sudo systemctl start openvpn
    sudo systemctl enable openvpn 
    sudo systemctl status openvpn 
    ;;
  *)
    # leave as is
    return
    ;;
  esac

}
install_fonts()
{
  printf "\n $YELLOW_HL Adding Nard fonts. $NC\n"
  case $OS in
  "Linux")
      cp -r -n "$(pwd)/fonts/fira_code_nf" "$HOME/.local/share/fonts"
      cp -n "$(pwd)/fonts/PowerlineSymbols.otf" "$HOME/.local/share/fonts"
      fc-cache -f -v
    ;;
  *)
    # leave as is
    return
    ;;
  esac
}

zsh_settings()
{
  case $OS in
  "Linux")
    # Check if the oh-my-zsh is installed
    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    if [ -d "$ZSH_CUSTOM" ]; then
      git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k # clone powerlevel10k theme 
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting # clone syntax highlighting plugin
      git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions # clone autosuggestions plugin 
    fi
  ;;
  *)
    # leave as is
    return
    ;;
  esac
}

stow_configs()
{
  case $OS in
  "Linux")
    
    # Move .zshrc tile if already created
    ZSHRC="$HOME/.zshrc"
    if [ -f "$ZSHRC" ]; then
      sudo mv $ZSHRC $HOME/.zshrc.pre-dotfiles-install
    fi

    # Move .p10k.zsh tile if already created
    ZSH_THEME="$HOME/.p10k.zsh"
    if [ -f "$ZSH_THEME" ]; then
      sudo mv $ZSH_THEME $HOME/.p10k.zsh.pre-dotfiles-install
    fi

    # Move .gitconfig tile if already created
    GIT_CONF="$HOME/.gitconfig"
    if [ -f "$GIT_CONF" ]; then
        sudo mv $GIT_CONF $HOME/.gitconfig.pre-dotfiles-install
    fi
    
    stow --target=$HOME linux/

  ;;
  *)
    # leave as is
    return
    ;;
  esac
}

main() {
  # Performs initial setup for new systems (Installing basic packages)
  system_setup

  # Add Package managers
  install_package_manager

  # Install basic applications
  install_tools

  # Install Fonts
  install_fonts

  # Create stow (symlinks) for config files
  stow_configs

  # configure zsh & oh-my-zsh
  zsh_settings

  # Reboot system 
  if [ "$RESTART_REQUIRED" = true ]; then
    printf "${GREEN}System will require to reboot after upgrade, You need to run this script again once the system reboots; would you like to reboot now? [Y/n]${NC}\n"
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
