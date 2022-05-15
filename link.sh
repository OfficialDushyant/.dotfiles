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

link_gitconfig()
{

    echo "Git config"
    #  GIT_CONF="$HOME/.gitconfig"
    # if [ -f "$GIT_CONF" ]; then
    #     sudo mv $GIT_CONF $HOME/.gitconfig.pre-dotfiles-install
    # fi
    
}

main()
{
    if [ $# -gt 0 ]; then
        for conf in "$@"
        do 
            case $conf in 
            ".gitconfig")
                echo "Gitconfig"
            ;;    
            *)
                printf "$RED Configuration instruction for \"$conf\" dose not exist.$NC"    
            ;;
            esac
        done

    else 
        echo "run all"
    fi
}

main $@