# Windows like clipboard

This requires [clipmenu](https://github.com/cdown/clipmenu) to be installed for collecting clips.

You need to call the `clipmenud` daemon at the startup, I have this configured in the `~/.xinitrc` file just before executing `bspwm`
```bash title=".xinitrc"
...
clipmenud &
exec bspwm
```

With this `clipmenud` will start collecting all the things which you copy with `CTRL-C`.

Add a rule to `~/.config/sxhkd/sxhkdrc` to use the clipboard
```bash title="sxhkdrc"
# clipboard
alt + v
    CM_LAUNCHER=rofi clipmenu \
        -location 1 \
        -m -3 \
        -no-show-icons \
        -theme-str '* \{ font: 10px; \}' \
        -theme-str 'listview \{ spacing: 0; \}' \
        -theme-str 'window \{ width: 20em; \}'
```


