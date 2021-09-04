#!/bin/bash
set -e

# other misc useful packages
sudo pacman -S --noconfirm alacritty cronie htop mpv network-manager-applet neovim openssh picom pavucontrol starship stow terminus-font tmux ttf-inconsolata zsh

[ ! -d ~/.local ] && mkdir ~/.local

if [ ! -d ~/.dotfiles ]; 
then 
	git clone https://github.com/djjlewis/dotfiles.git ~/.dotfiles
	pushd ~/.dotfiles
	[ -f ~/.bashrc ] && mv ~/.bashrc ~/.bashrc.bak
	git checkout stow
	stow *
	popd
fi

if [ ! -d ~/aur/yay ];
then
	[ ! -d ~/.aur ] && mkdir ~/aur
	git clone https://aur.archlinux.org/yay.git ~/aur/yay
	pushd ~/aur/yay
	makepkg -si --noconfirm PKGBUILD
	popd
fi

if [ ! -f ~/.local/share/nvim/autoload/plug.vim ];
then
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

yay -S --noconfirm nerd-fonts-source-code-pro

# enable cron and add wallpaper job
sudo systemctl enable cronie.service
(crontab -l 2>/dev/null; echo "*/5 * * * * DISPLAY=:0 /home/dan/.local/bin/wallpaper") | crontab -

chsh -s /usr/bin/zsh
