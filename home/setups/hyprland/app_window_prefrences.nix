#INFO:
# My general prefrences on how some apps should behave
# To get an applications details, use 'hyprctl clients' in console
[
    "float, title:^(Picture-in-Picture)"
    "size 960 540, title:^(Picture-in-Picture)"
    "move 25%-, title:^(Picture-in-Picture)"
    "float, com.vixalien.decibels"
    "float, imv" 
    "move 25%-, imv"
    "size 960 540, imv"
    
    "float, mpv" 
    "move 25%-, mpv"
    "size 960 540, mpv"
    "float, nemo"
    "move 25%-, nemo"
    "size 960 540, nemo"
    "animation slide up, title:^(nvim)$"
    "noblur,^(floorp)$"
    "float, org.gnome.TextEditor"
    "move 25%-, org.gnome.TextEditor"
    "size 960 540, org.gnome.TextEditor"
]
