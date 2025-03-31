# Arguments in goof

[Goof](https://github.com/sneaky-potato/goof) is a stack based language which has a concatenative syntax. Consider the following goof source code:

```pascal title="test.goof"
10 1 dump dump
```

This gets converted to the following assembly output:

```asm title="output.asm"
segment .text
dump:
    push    rbp
    ...
    syscall
    nop
    leave
    ret
global _start
_start:
addr_0:
    ;; -- push 10 --
    push 10
addr_1:
    ;; -- push 1 --
    push 1
addr_2:
    ;; -- dump --
    pop rdi
    call dump
addr_3:
    ;; -- dump --
    pop rdi
    call dump
addr_4:
    mov rax, 60
    mov rdi, 0
    syscall
segment .bss
mem resb 640000
```

Now we have pushed 10 and 1 on top of stack and tried dumping them to stdout which works fine like so:
```console
10
1
```

However something interesting happens if we try to compile the following code:
```pascal title="test.goof"
dump dump
```

The output is `argc` and `argv` respectively:
```
1
140725129002957
```

So, yes this can be used to access the command line arguments without actually implementing any operation to get them in goof. This is completely unintended and was discovered accidentally in one of his streams.

I wanted to print the argv elements in [goof](https://github.com/sneaky-potato/goof), consider the following program:
```pascal title="test.goof"
drop // get rid of argc
// try printing 100 bytes of string pointed to by argv
100 swap 1 1 syscall3 drop
```

The following interesting output appears on running as follow:
```console
./output foo bar
```

```console
./outputfoobarALACRITTY_LOG=/tmp/Alacritty-4428.logALACRITTY_SOCKET=/run/user/1000/Alacritty-:0-     
```

This is argv but since we printed 100 bytes, it started printing the env varaibles of my system, how cool is that?
