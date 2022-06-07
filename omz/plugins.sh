#!/bin/sh

. $(pwd)/constants.sh

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"


zsh_syntax_highlighting()
{
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
}

zsh_autosuggestions()
{
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
}

zsh_wakatime()
{
    if [ "$1" = "--link" ]; then
        case $OS in
        "Linux")
            git clone https://github.com/sobolevn/wakatime-zsh-plugin.git $ZSH_CUSTOM/plugins/wakatime

            WAKATIME_CONF="$HOME/.wakatime.cfg" # Requires .wakatime.cfg config files to create from sample file
            
            if [ -f "$WAKATIME_CONF" ]; then
                sudo mv $WAKATIME_CONF $HOME/.wakatime.pre-config-run.$TIME
            fi

            ln -s $DOTFILES_CONF/.wakatime.cfg $HOME
            ls -l $WAKATIME_CONF
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
            rm -rf $ZSH_CUSTOM/plugins/wakatime
            WAKATIME_CONF="$HOME/.wakatime.cfg"
            unlink $WAKATIME_CONF
        ;;
        *)
            # leave as is
            return
            ;;
        esac
    fi
}