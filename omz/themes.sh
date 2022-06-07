#!/bin/sh

. $(pwd)/constants.sh

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

p10k_config()
{
    # Clone the theme in omz customs dir
    git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

    if [ "$1" = "--link" ]; then
        case $OS in
        "Linux")
            P10K_CONF="$HOME/.p10k.zsh"

            if [ -f "$P10K_CONF" ]; then
                sudo mv $P10K_CONF $HOME/.p10k.pre-config-run.$TIME
            fi

            ln -s $DOTFILES_CONF/.p10k.zsh $HOME
            ls -l $P10K_CONF
            ;;
        *)
            # leave as is
            return
            ;;
        esac
    fi
    if [ "$1" = "--unlink" ]; then
        case $OS in
        "Linux")
            P10K_CONF="$HOME/.p10k.zsh"
            unlink $P10K_CONF
            ;;
        *)
            # leave as is
            return
            ;;
        esac
    fi
}