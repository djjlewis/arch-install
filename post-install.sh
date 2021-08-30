sudo pacman -S --noconfirm xorg-server xorg-xinit xorg-apps xterm mesa xf86-video-vesa xf86-video-vmware xclip xdg-utils xdg-user-dirs xorg-xinit alacritty cronie htop mpv network-manager-applet neovim picom pavucontrol starship terminus-font stow tmux ttf-inconsolata zsh

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

chsh -s /usr/bin/zsh
