# Help menu for hotkeys

Since I use a tiling window manager there are so many hotkeys I forget.
Hence I have a help menu to remember the keybindings using a rofi window.

Make a bash file for spawning the help menu `~/.config/sxhkd/sxhkd-help`
```bash title="sxhkd-help"
#!/bin/bash

awk '/^[a-z]/ && last {print "<small>",$0,"\t",last,"</small>"} {last=""} /^#/{last=$0}' ~/.config/sxhkd/sxhkdrc |
    column -t -s $'\t' |
    rofi -dmenu -i -markup-rows -no-show-icons -width 1000 -lines 15 -yoffset 40
```

Then add the following key binding to `~/.config/sxhkd/sxhkdrc`
```bash title="sxhkdrc"
# help menu
super + slash
    ~/.config/sxhkd/sxhkd-help
```
