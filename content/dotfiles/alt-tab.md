# Cycle windows

The one feature I missed the most in a tiling window manager

Add the following rule to `~/.config/sxhkd/sxhkdrc` to select windows just how alt-tab works in KDE and Gnome
```bash title="sxhkrdc"
# focus the next/previous window in the current desktop
alt + Tab
    rofi -modi window -show window -hide-scrollbar -padding 50 -line-padding 4 -auto-select \
         -kb-cancel "Alt+Escape,Escape" \
         -kb-accept-entry "!Alt+Alt_L,Return" \
         -kb-row-down "Alt+Tab,Alt+Down" \
         -kb-row-up "Alt+ISO_Left_Tab,Alt+Up" \
         -selected-row 1
```
