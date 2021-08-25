mkdir ~/aur

cd ~/aur
git clone https://aur.archlinux.org/yay.git 
cd ~/aur/yay
makepkg -si --noconfirm

yay -S --noconfirm polybar nerd-fonts-source-code-pro
