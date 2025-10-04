> How to effectively alt-tab when editing a large code base?

## Buffer flying
You could use a fuzzy finder like [telescope](https://github.com/nvim-telescope/telescope.nvim) or [fzf-lua](https://github.com/ibhagwan/fzf-lua) but there is another method which feels to me more like alt-tab.
Set the following key bind in your configuration

```lua title="keymaps.lua"
vim.keymap.set("n", "<C-b>", ":ls<cr>:b<space>")
```

Now, just press Ctrl-b and then keep hitting tab till you reach the file you want to jump to next.

## Buffer sprinting
You could also use map keys to next and previous buffers for faster cycles.

```lua title="kwymaps.lua"
vim.keymap.set("n", "]b", ":bnext<cr>")
vim.keymap.set("n", "[b", ":bprev<cr>")
```
