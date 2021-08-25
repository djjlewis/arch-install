sudo systemctl enable cronie.service
(crontab -l 2>/dev/null; echo "*/5 * * * * DISPLAY=:0 /home/dan/.local/bin/wallpaper") | crontab -

git clone https://gitlab.com/dwt1/wallpapers.git ~/Pictures/wallpaper
