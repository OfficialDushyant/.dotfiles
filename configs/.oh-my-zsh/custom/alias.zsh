#Edit Config files
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"

if [ -x "$(command -v exa)" ]; then
   alias ls="exa --icons --grid"
   alias ll="exa --long --icons --all --group --grid"
   alias lt="exa --tree --level=2 --icons --all"
   alias lr="exa --icons --recurse --group --grid"
fi

alias mkdir='mkdir -pv'                     
alias mv='mv -iv'                           
alias finder='open -a Finder ./'            
alias ~="cd ~"                              
alias c=clear
alias openvpn3=openvpn
alias projects='cd /media/"$USER"/Projects'

#functions 

cd() { builtin cd "$@"; ll; }               
free () { (sudo kill -9 $(sudo lsof -t -i:$@)) }
trash () { command gio trash "$@"; }     
