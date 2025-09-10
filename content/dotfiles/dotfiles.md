# Dotfiles

Some files and code snippets here are very important for my use cases. I have documented some snippets that one may find interesting.

> [!IMPORTANT]  
> Dotfiles are configuration files in Unix-like systems, typically found in a user's home directory and starting with a dot (e.g., .bashrc). They store settings and customizations for various applications and tools.

> [!WARNING]
> Some of the snippets depend on other programs and will only work when they are properly configured. User descretion is advised while copy-pasting. However if the words used in the following list makes sense to you then feel free to copy paste as you like.

## Setup
I primarily use arch linux with ***NO*** [desktop environment](https://en.wikipedia.org/wiki/Desktop_environment).
My setup consists of the following:
- [polybar](https://github.com/polybar/polybar) as a status bar
- [rofi](https://github.com/davatorium/rofi) as a window switcher
- [bspwm](https://github.com/baskerville/bspwm) as a tiling window manager
- [sxhkd](https://github.com/baskerville/sxhkd) as a hotkey daemon

> [!NOTE]
> Please have a look at [my dotfiles](https://github.com/sneaky-potato/dotfiles) for more things like nvim, starship and alacritty setup

Over the years I have scoured the internet for fixing my dotfiles and here I document the most interesting / useful cases.

- How to spawn a [[scratchpad-terminal|terminal as scratchpad]]
- Display a [[sxhkd-help-menu|sxhkd help menu]] whenever you forget any commands
- Get windows like [[clipboard]]
- Enable [[alt-tab]] window switching with rofi
