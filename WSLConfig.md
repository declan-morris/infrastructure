# Set up for new install on windows with WSL

```

apt update
apt upgrade

# install zsh
apt install zsh

# install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install p10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# change .zshrc to have the p10k theme
ZSH_THEME="powerlevel10k/powerlevel10k"

```