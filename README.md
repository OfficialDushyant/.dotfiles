# Setting up new Linux system.

### STEP 1 Update and upgrade `apt`
```
sudo apt update && sudo apt upgrade
```
**Note:** *You may require to reboot your system for some of the updates to apply*

### STEP 2 Setup `ZSH`
```
sudo apt-get install zsh
```

### STEP 3 Install `Oh My Zsh`
```
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

### STEP 4 Install zsh theme `Powerlevel10k`
```
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
```

### STEP 5 Run `instal.sh` file from .dotfiles
```
$ sudo chmod u+x $HOME/.dotfiles/install.sh
```
```
$ sh $HOME/.dotfiles/install.sh 
```
**Note:** *System will require to reboot for the changes to take effect. So type `Y` if script ask for reboot or manually restart the system.*

---
# Setup new MacOS system

>Under development...

---

## Upcoming features 
- [x] Oh-my-zsh setup for linux.
- [x] Managing config files for linux using GNU Stow.
- [ ] System setup script for MacOS.
- [ ] Oh-my-zsh setup for MacOS.
- [ ] Managing config files for MacOS using GNU Stow.
- [ ] List of tools and app I use for development and URL to get them.
