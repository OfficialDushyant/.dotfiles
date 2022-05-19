#!/bin/sh

# TODO 
# ? Adding apps through appimage
    # ? Validate file desktop-file-validate <PATH to .desktop file>
    # ? Install (Add to .local/share/applications ) desktop-file-install --dir=$HOME/.local/share/applications <PATH to .desktop file>
# Load constants
. $(pwd)/constants.sh

# Draw ascii art in terminal 
draw_ascii () 
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


main()
{
    # Install dialog command line tool
    printf "\n$YELLOW_HL Script requires to install \"dialog\" command line tool to take user inputs.$NC\n"
    sudo apt-get install -y dialog
    # Checks for the the Specific OS.
    case $OS in 
    "Linux")
        draw_ascii

        # Get user selection for list of app options to install in Linux system
        OPTIONS=$(dialog --stdout --no-tags --clear --backtitle "Installer Options..." --title "Software Selection" \
            --checklist "Use SPACE to select/deselct options and OK when finished."  30 100 30 \
            Bitwarden "Bitwarden client for password manger" off \
            Authy "Authy 2FA TOTP generator" off \
            > install_options.txt)

        OPTIONS=$(cat install_options.txt | tr -s ' ' '\n')

        # Install apps for Specific Linux Distribution 
        case $DIST in 
        Pop!_OS | Ubuntu)
            #! Install apps for Linux
        ;;
        *)
        printf "$DIST for $OS is not yet supported by this script"
        exit 1
        ;;
        esac
    ;;
    "Darwin")
        #! Instal apps for macOS 
    ;; 
    *)
    exit 1
    ;;
    esac
}
main