# Scratch pad

A scratch pad terminal for quickly running a command on shell without having to start another instance of the terminal somewhere else and coming back.

Add the following rule to `~/.config/sxhkdrc`
```bash title="sxhkdrc"
# scratchpad
alt + Return
    . ~/.config/bspwm/scpad
```

And add the following file bash file `~/.config/bspwm/scpad` for launching the scratch pad
```bash title="scpad"
#!/usr/bin/env bash

winclass="$(xdotool search --class scpad)"
if [ -z "$winclass" ]; then
    alacritty --class scpad
else
    if [ ! -f /tmp/scpad ]; then
        touch /tmp/scpad && xdo hide "$winclass"
    elif [ -f /tmp/scpad ]; then
        rm /tmp/scpad && xdo show "$winclass"
    fi
fi
```

Finally add a bspwm rule here `~/.config/bsowm/bspwmrc`
```bash title="baspwmrc"
bspc rule -a scpad sticky=on state=floating rectangle=800x500+550+200
```
