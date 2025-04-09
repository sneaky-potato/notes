# Normal command

Consider this piece of text
```text
return {
    name,
    cargo_type,
    fame,
}
```
- visually select the text inside return and run the following `:norm f,i.append()`
- This will run the jey stroke sequence `f,i.append()` on the selected text, resulting in the following text
```text
return {
    name.append(),
    cargo_type.append(),
    fame.append(),
}
```
- go one step ahead and combine complex key strokes, again visually select the text inside return
- `:norm ^yt.f(a"^[pa"` will result in following text (you have to press ctrl-v followed by escape key on keyboard to get escape keystroke `^[`)
```text
return {
    name.append("name"),
    cargo_type.append("cargo_type"),
    fame.append("fame"),
}
```
