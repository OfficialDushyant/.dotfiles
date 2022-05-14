# Setting up new Linux system.

<details>    
<summary> Click to expand</summary>

### STEP 0 Clone this repo in your home folder
```
git clone https://github.com/dushyantDevTips/.dotfiles.git
```
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

### STEP 6 Change fonts for the terminal app

You will require to change fonts for you terminal else the terminal prompt may seem glitched.
To do that go to preferences of your gnome terminal and set `Fir Code` as custom font setting is your active profile.

![Setting Terminal app fonts](/linux/assets/fonts-preferance.png)

**Note:** *The example in Image is taken from `Pop_OS` for `GNOME Terminal app` for different flavour of linux and applications would be different.* 
</details>

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
