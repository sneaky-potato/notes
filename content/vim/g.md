# Goat command

Command structure resembles substitute command- `:g/re/command` will run `command` over all **lines** (not words) matching the regular expresson pattern `re`

- `:g/re` will print at the bottom of the screen all lines matching pattern `re` (default command `p` is used here)
- `:g/pattern/normal @a` plays the `a` macro on all lines matching pattern
- `:g/pattern/normal A.` appends a dot `.` on all lines matching pattern
- `:g/console/g/two/d` is an example of recursive command
    - `console` first matches lines containing `console`
    - and then second g filters out matches containing `two` from the earlier matched
    - then applies `d` command
- `:g/pattern1/,/pattern2/command` makes Vim will apply the command within pattern1 and pattern2
    - `/^$/` matches empty lines (with no character)
    - `:g/^$/,/./j` basically matches empty lines (`^$`) and non empty lines (`.`) and joins them (`j`)
- Delimiter can be changed like the substitute command, use any character except for alphabets, numbers, ", |, and \.
    - `:g@console@d` deletes all lines containing console
- g and s command can be conviniently combined
    - `:g@one@s+const+let+g` matches lines containing `one`
    - and then uses the substitute to replace `const` with `let` (last g for applying substitute on all matches within the matched lines)
    - could also use `g/one/s/const/let/g`
- `:g/TODO/t $` copies all lines matching pattern `TODO` at the end of file (:h :copy)
    - Invert also works `:g!/TODO/t $` copy everything except TODOs at end of file
    - `:g/TODO/m $` moves all TODOs instead of copying them
- `:g/console/d _` deletes all lines matching pattern `console` and puts them in black hole register `_`
