#!/bin/sh

# TODO 
# ? Adding apps through appimage
    # ? Validate file `desktop-file-validate <PATH to .desktop file>`.
    # ? Install (Add to .local/share/applications ) `desktop-file-install --dir=$HOME/.local/share/applications <PATH to .desktop file>`.
# Load constants
. $(pwd)/constants.sh

# Draw ascii art in terminal 
draw_ascii() 
{
  case $OS in
  "Linux")
    printf "\n$GREEN
     _      _                  
    | |    (_)                 
    | |     _ _ __  _   ___  __
    | |    | | '_ \| | | \ \/ /
    | |____| | | | | |_| |>  < 
    |______|_|_| |_|\__,_/_/\_\ \n\n\n$NC"
    ;;
  "Darwin")
    printf "\n$GREEN
                            ____   _____ 
                           ____   _____ 
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

app_installs_for_linux()
{
    # Create log file with system info
    LogFile="$HOME/.dotfiles/SYSTEM_INFO.log"
    if [ ! -f "$LogFile" ]; then
      printf "OS Info\n\n$(cat /etc/os-release)\n\n\n" >>$LogFile
      printf "CPU Info\n\n$(sudo lscpu)\n\n\n" >>$LogFile
      printf "GPU Info\n\n$(sudo lshw -C display)\n\n\n" >>$LogFile
      printf "Memory Info\n\n$(sudo lshw -C memory)\n\n\n" >>$LogFile
      printf "Volume Info\n\n$(sudo lshw -C volume)\n\n\n" >>$LogFile
    fi

    # Install apps for Specific Linux Distribution 
    case $DIST in 
    # Debian based os support.
    Pop!_OS | Ubuntu)
      #! Install apps for Linux
      case $1 in 
      VScode)
        printf "$WHITE$BLUE_HL Installing Visual Studio Code$NC\n"
        sudo dpkg --install $HOME/.dotfiles/linux/dpkg/vscode.deb
      ;;
      Flameshot)
        printf "$WHITE$BLUE_HL Installing Flameshot screenshot utility$NC\n"
        sudo apt install flameshot
      ;;
      CopyQ)
        printf "$WHITE$BLUE_HL Installing CopyQ clipboard history utility$NC\n"
        sudo add-apt-repository ppa:noobslab/indicators
        sudo apt update
        sudo apt install copyq
      ;;
      *)
        # Do nothing here
      ;;
      esac  
    ;;
    *)
    printf "$DIST for $OS is not yet supported by this script"
    exit 1
    ;;
    esac

}

main()
{
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
                  "Neofetch" "Neofetch CLI tool for system info" off \
                  "Exa" "exa CLI tool for color code ls command" off \
                  "VScode" "VScode code editor https://code.visualstudio.com/" off \
                  "Flameshot" "Screenshot application for linux" off \
                  "CopyQ" "CopyQ clipboard history utility" off \
                  > install_options.txt)    
        # Clear the screen
        clear
        OPTIONS=$(cat install_options.txt | tr -s ' ' '\n')  
        app_installs_for_linux "$OPTIONS"
    fi

    exit 0
}
main