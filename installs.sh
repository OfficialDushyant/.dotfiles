#!/bin/sh

# TODO
# ? Adding apps through appimage
# ? Validate file `desktop-file-validate <PATH to .desktop file>`.
# ? Install (Add to .local/share/applications ) `desktop-file-install --dir=$HOME/.local/share/applications <PATH to .desktop file>`.
# Load constants
. $(pwd)/constants.sh

# Draw ascii art in terminal
draw_ascii() {
  case $OS in
  "Linux")
    printf "\n$GREEN
     _      _                  
    | |    (_)                 
    | |     _ _ __  _   ___  __
    | |    | | '_ \| | | \ \/ /
    | |____| | | | | |_| |>  < 
    |______|_|_| |_|\__,_/_/\_\ \n\n\n$NC"

    # Create log file with system info
    LogFile="$HOME/.dotfiles/SYSTEM_INFO.log"
    if [ ! -f "$LogFile" ]; then
      printf "OS Info\n\n$(cat /etc/os-release)\n\n\n" >>$LogFile
      printf "CPU Info\n\n$(sudo lscpu)\n\n\n" >>$LogFile
      printf "GPU Info\n\n$(sudo lshw -C display)\n\n\n" >>$LogFile
    fi
    ;;
  "Darwin")
    printf "\n$GREEN
                            ____   _____ 
                           / __ \ / ____|
     _ __ ___   __ _  ___ | |  | | (___  
    |  _   _ \\ / _ | / __ | |  | |\___ \ 
    | | | | | | (_| | (__ | |__| |____) |
    |_| |_| |_|\__,_|\___ |\____/|_____/ \n\n\n$NC"
    ;;
  *)
    printf "$OS is not supported by this script"
    ;;
  esac
}

app_installs() {

  for app in $(echo $1 | sed "s/;/ /g"); do
    # Install bitwarden
    if [ $app = "Bitwarden" ]; then
      install_bitwarden
    fi
    # Install Authy
    if [ $app = "Authy" ]; then
      install_authy
    fi
    # echo $app
  done
  # case $1 in
  # Bitwarden)
  #   printf "$WHITE$BLUE_HL Installing Bitwarden desktop client$NC\n"
  #   desktop-file-validate $HOME/.dotfiles/linux/appimages/Bitwarden.desktop
  #   desktop-file-install --dir=$HOME/.local/share/applications $HOME/.dotfiles/linux/appimages/Bitwarden.desktop
  #   update-desktop-database $HOME/.local/share/applications
  #   printf "$GREEN Bitwarden desktop client appimage is Installed$NC\n"
  # ;;
  # Authy)
  #   printf "$WHITE$BLUE_HL Installing Authy 2FA TOTP generator$NC\n"
  #   printf "$RED Installing Authy requires to install snap package manager to be installed$NC\n"
  #   sudo apt install snapd
  #   sudo snap install authy
  #   printf "$GREEN authy snap package is installed Installed$NC\n"
  # ;;
  # Neofetch)
  #   printf "$WHITE$BLUE_HL Installing Neofetch CLI utility$NC\n"
  #   sudo apt install neofetch
  # ;;
  # Exa)
  #   printf "$WHITE$BLUE_HL Installing exa cli colorized ls replacement tool$NC\n"
  #   sudo apt install exa
  # ;;
  # VScode)
  #   printf "$WHITE$BLUE_HL Installing Visual Studio Code$NC\n"
  #   sudo dpkg --install $HOME/.dotfiles/linux/dpkg/vscode.deb
  #   ;;
  # Flameshot)
  #   printf "$WHITE$BLUE_HL Installing Flameshot screenshot utility$NC\n"
  #   sudo apt install flameshot
  #   ;;
  # CopyQ)
  #   printf "$WHITE$BLUE_HL Installing CopyQ clipboard history utility$NC\n"
  #   sudo add-apt-repository ppa:noobslab/indicators
  #   sudo apt update
  #   sudo apt install copyq
  #   ;;
  # *)
  #   printf $1
  #   printf "$WHITE$BLUE_HL Option may not be configured.$NC\n"
  #   # Do nothing here
  #   ;;
  # esac
}

install_bitwarden() {
  case $OS in
  "Linux")
    case $DIST in
    Ububtu | Pop!_OS)
      printf "$WHITE$BLUE_HL Installing Bitwarden desktop client$NC\n"
      desktop-file-validate $HOME/.dotfiles/linux/appimages/Bitwarden.desktop
      desktop-file-install --dir=$HOME/.local/share/applications $HOME/.dotfiles/linux/appimages/Bitwarden.desktop
      update-desktop-database $HOME/.local/share/applications
      printf "$GREEN Bitwarden desktop client appimage is Installed$NC\n"
      ;;
    esac
    ;;
  "Darwin")
    brew install bitwarden
    ;;
  *)
    # leave as is
    return
    ;;
  esac
}

install_authy() {
  case $OS in
  "Linux")
    case $DIST in
    Ububtu | Pop!_OS)
      printf "$WHITE$BLUE_HL Installing Authy 2FA TOTP generator$NC\n"
      printf "$RED Installing Authy requires to install snap package manager to be installed$NC\n"
      sudo apt install snapd
      sudo snap install authy
      printf "$GREEN authy snap package is installed Installed$NC\n"
      ;;
    *)
      printf "Script is not supporting $DIST Linux distribution yet."
      ;;
    esac
    ;;
  "Darwin")
    printf "$WHITE$BLUE_HL Installing Authy 2FA TOTP generator$NC\n"
    brew install --cask authy
    printf "$GREEN authy snap package is installed Installed$NC\n"
    ;;
  *)
    # leave as is
    return
    ;;
  esac
}

main() {
  # Draw ascii art for specific system
  draw_ascii

  printf "\n$WHITE$BLUE_HL Script requires to install \"dialog\" command line tool to take user inputs.$NC\n"
  # Update and upgrade apt
  sudo apt update && sudo apt upgrade
  # Install dialog command line tool
  sudo apt-get install dialog

  # Run installs specific to Linux OS
  if [ "$OS" = "Linux" ]; then
    # Get user selection for list of app options to install in Linux system
    OPTIONS=$(dialog --stdout --title "Select apps to install from the list" --checklist "Use space to select or deselect, and arrow key to navigate" 40 100 40 \
      "Bitwarden" "Bitwarden client for password manger https://bitwarden.com/" off \
      "Authy" "Authy 2FA TOTP generator https://authy.com/ Requires Snap package manager" off \
      "Neofetch" "Neofetch CLI tool for system info https://github.com/dylanaraps/neofetch" off \
      "Exa" "exa CLI tool for color code ls command https://the.exa.website/" off \
      "VScode" "VScode code editor https://code.visualstudio.com/" off \
      "Flameshot" "Screenshot application for linux https://flameshot.org/" off \
      "CopyQ" "CopyQ clipboard history utility https://hluk.github.io/CopyQ/" off \
      >install_options.txt)
    # Clear the screen
    clear
    OPTIONS=$(cat install_options.txt | tr -s ' ' ';')
    # Install selected tools
    app_installs "$OPTIONS"
  fi

  exit 0
}
main
