# Direct Threaded Code

Also called [Labels as Values](https://gcc.gnu.org/onlinedocs/gcc/Labels-as-Values.html) in the official docs for GCC, it is basically a combination of two new features of C.

The first involves taking addresses of labels into a void* like so

```c
void* labelAddr = &&someLabel;

someLabel:
    // code
```

The second is invoking a goto on a variable expression instead of a known label, like so

```c
void* table[];
goto *table[pc];
```

Consider the following vm implementation using a switch statement:

```c
#define OP_HALT     0x0
#define OP_INC      0x1
#define OP_DEC      0x2
#define OP_MUL2     0x3
#define OP_DIV2     0x4
#define OP_ADD7     0x5
#define OP_NEG      0x6

int interp_switch(unsigned char* code, int initval) {
    int pc = 0;
    int val = initval;

    while (1) {
        switch (code[pc++]) {
            case OP_HALT: return val;
            case OP_INC: val++; break;
            case OP_DEC: val--; break;
            case OP_MUL2: val *= 2; break;
            case OP_DIV2: val /= 2; break;
            case OP_ADD7: val += 7; break;
            case OP_NEG: val = -val; break;
            default: return val;
        }
    }
}
```

And now consider the computed goto version of the same control flow in the code

```c
int interp_cgoto(unsigned char* code, int initval) {
    /* The indices of labels in the dispatch_table are the relevant opcodes
    */
    static void* dispatch_table[] = {
        &&do_halt, &&do_inc, &&do_dec, &&do_mul2,
        &&do_div2, &&do_add7, &&do_neg
    };

    #define DISPATCH() goto *dispatch_table[code[pc++]]

    int pc = 0;
    int val = initval;

    DISPATCH();
    while (1) {
        do_halt:
            return val;
        do_inc:
            val++;
            DISPATCH();
        do_dec:
            val--;
            DISPATCH();
        do_mul2:
            val *= 2;
            DISPATCH();
        do_div2:
            val /= 2;
            DISPATCH();
        do_add7:
            val += 7;
            DISPATCH();
        do_neg:
            val = -val;
            DISPATCH();
    }
}
```

On examining the disassembly of the switch version, one can see that it does the following:
- Execute the operation itself (i.e. `val *= 2` for `OP_MUL2`)
- `pc++`
- Check the contents of `code[pc]`. If within bounds (<= 6), proceed. Otherwise return from the function.
- Jump through the jump table based on offset computed from `code[pc]`.

On the other hand, the computed goto version does this:
- Execute the operation itself
- `pc++`
- Jump through the jump table based on offset computed from `code[pc]`.

The difference: "bounds check" step of the switch. This way the labels within the interpreter function can be stored in the threaded code for super-fast dispatching. 
