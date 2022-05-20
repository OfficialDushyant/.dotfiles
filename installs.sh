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
                          / __ \ / ____|
    _ __ ___   __ _  ___  | |  | | (___  
    | '_ ` _ \ / _` |/ __ | |  | |\___ \ 
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
    Pop!_OS | Ubuntu)
      #! Install apps for Linux
      for app in $(echo $OPTIONS | sed "s/\n/ /g")
      do
        echo "Installing.... $app"
      done
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
    # Install dialog command line tool
    sudo apt-get install dialog
    
    # Run installs specific to Linux OS
    if [ "$OS" = "Linux" ]; then
        # Get user selection for list of app options to install in Linux system
        OPTIONS=$(dialog --stdout --title "Select apps to install from the list" --checklist "Use space to select or deselect, and arrow key to navigate" 20 78 4 \
                  "Bitwarden" "Bitwarden client for password manger https://bitwarden.com/" off \
                  "Authy" "Authy 2FA TOTP generator https://authy.com/" off \
                  "neofetch" "Neofetch CLI tool for system info" off \
                  "Exa" "exa CLI tool for color code ls command" off \
                  "VScode" "VScode code editor https://code.visualstudio.com/" off \
                  > install_options.txt)    
        # Clear the screen
        clear
        OPTIONS=$(cat install_options.txt | tr -s ' ' '\n')  
        echo "$OPTIONS"
    fi

    exit 0
}
main