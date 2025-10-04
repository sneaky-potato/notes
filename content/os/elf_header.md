# ELF Header

The structure looks something like this

```c
#define EI_NIDENT 16

typedef struct {
    unsigned char   e_ident[EI_NIDENT];
    Elf32_Half      e_type;
    Elf32_Half      e_machine;
    Elf32_Word      e_version;
    Elf32_Addr      e_entry;
    Elf32_Off       e_phoff;
    Elf32_Off       e_shoff;
    Elf32_Word      e_flags;
    Elf32_Half      e_ehsize;
    Elf32_Half      e_phentsize;
    Elf32_Half      e_phnum;
    Elf32_Half      e_shentsize;
    Elf32_Half      e_shnum;
    Elf32_Half      e_shstrndx;
} Elf32_Ehdr;

typedef struct {
    unsigned char   e_ident[EI_NIDENT];
    Elf64_Half      e_type;
    Elf64_Half      e_machine;
    Elf64_Word      e_version;
    Elf64_Addr      e_entry;
    Elf64_Off       e_phoff;
    Elf64_Off       e_shoff;
    Elf64_Word      e_flags;
    Elf64_Half      e_ehsize;
    Elf64_Half      e_phentsize;
    Elf64_Half      e_phnum;
    Elf64_Half      e_shentsize;
    Elf64_Half      e_shnum;
    Elf64_Half      e_shstrndx;
} Elf64_Ehdr;
```

---
An example of raw bytes from a 32 bit ELF header

```bash title="exit32.dmp"
#  -------------- ELF HEADER --------------
                # all numbers are in base 16
                # 00 number of bytes to be used in the ELF
7F 45 4C 46     # 04 e_ident[EI_MAG]: ELF magic bytes
01              # 05 e_ident[EI_CLASS]: 1=32-bit, 2=64-bit
   01           # 06 e_ident[EI_DATA]: 1=little-endian, 2=big=endian
      01        # 07 e_ident[EI_VERSION]: ELF header version
         00     # 08 e_ident[EI_OSABI]: Target OS ABI; should be 0 for System V
00              # 09 e_ident[EI_ABIVERSION]: ABI version; 0 is ok for Linux
   00 00 00     # 0C e_ident[EI_PAD]: unused, should be 0
00 00 00 00     # 10

02 00           # 12 e_type: object file type; 2=executable
      03 00     # 14 e_machine: instruction set architecture; 03=x86, 3E=amd64
01 00 00 00     # 18 e_version: ELF identification version; must be 1
54 80 04 08     # 1C e_entry: memory address of entry point (where process starts)
34 00 00 00     # 20 e_phoff: file offset where program headers begin

00 00 00 00     # 24 e_shoff: file offset where section headers begin
00 00 00 00     # 28 e_flags: 0 for x86

34 00           # 2A e_ehsize: size of this header (34: 32-bit, 40: 64-bit)
      20 00     # 2C e_phentsize: size of each program header (20: 32-bit, 38: 64-bit)
01 00           # 2E e_phnum: #program headers
      28 00     # 30 e_shentsize: size of each section header (28: 32-bit, 40: 64-bit)

00 00           # 32 e_shnum: #section headers
      00 00     # 34 e_shstrndx: index of section header containing section names

#  -------------- ELF HEADER --------------
```

### e_ident

On an Ubuntu machine this looks something like this:

```bash
$ xxd -g 1 hello | head -1
00000000: 7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00  .ELF............
```

Notice this is actually the magic bytes of the elf

`7f` is followed by `45 4c 46` which mean ELF when converted into hexadecimal (ascii for ELF)

```bash
$ readelf -h /bin/ls
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              DYN (Position-Independent Executable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x55f0
  Start of program headers:          64 (bytes into file)
  Start of section headers:          140224 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         14
  Size of section headers:           64 (bytes)
  Number of section headers:         28
  Section header string table index: 27
```

## e_type

This identifies the object file type

| Name | Value | Meaning | Notes |
| --- | --- | --- | --- |
| ET_NONE | 0 | No file type |  |
| ET_REL | 1 | Relocatable file: object files | `gcc -c foo.c -o foo.o` |
| ET_EXEC | 2 | Executable file: -no-pie exe | `gcc -no-pie foo.c -o foo` |
| ET_DYN | 3 | Shared object file: exe and shared libs | `gcc foo.c -o foo` 
`gcc -shared foo.c -o foo` |
| ET_CORE | 4 | Core file |  |

## e_machine

This specifies the required architecture for an individual file

| Value | Meaning |
| --- | --- |
| 0x03 | x86 Intel Architecture |
| 0x08 | MIPS |
| 0x28 | ARM |
| 0x3E | amd64 |
| 0xB7 | ARMv8 |
| 0xF3 | RISC-V |

## e_version

Always set to 1

## e_entry

This store the entry point address for executable.

For shared libraries, this stores the constructor address.

Otherwise 0

For executables:

| **e_machine** | **e_ident[EI_CLASS]** | **e_entry** | little endian |
| --- | --- | --- | --- |
| 0x0003 (x86) | 0x01 | 0x08048000 + offset (54 if 1 program header) | `54 80 04 08` |
| 0x003E (x86_64) | 0x02 | 0x40000000 + offset (78 if 1 program header) | `78 00 40 00 00 00 00 00`. |

[Why is the ELF execution entry point virtual address of the form 0x80xxxx](https://stackoverflow.com/questions/2187484/why-is-the-elf-execution-entry-point-virtual-address-of-the-form-0x80xxxxx-and-n)

## e_phoff

This member holds the program header table's file offset in bytes. If the file has no
program header table, this member holds zero. (Segments)

8x `00`: program header table offset, 0 if not present.

For executables:

| **e_machine** | **e_ident[EI_CLASS]** | **e_ehsize** | **e_phoff** |
| --- | --- | --- | --- |
| 0x0003 (x86) | 0x01 | 0x0038 | `34 00 00 00` |
| 0x003E (x86_64) | 0x02 | 0x0040 | `40 00 00 00 00 00 00 00` |

## e_shoff

This member holds the section header table's file offset in bytes. If the file has no
section header table, this member holds zero. (Sections)

Both of these offsets are relative to the beginning of the file

 `40` 7x `00` = `0x40`: section header table file offset, 0 if not present. 

## e_flags

Heavily architecture and OS dependent

## e_ehsize

Size of the ELF header (0x34 for 32 bit, 0x40 for 64 bit)

## e_phentsize

This member holds the size in bytes of one entry in the file's program header table;
all entries are the same size.

(0x20 for 32 bit, 0x38 for 64 bit)

## e_phnum

This member holds the number of entries in the program header table. Thus the
product of `e_phentsize` and `e_phnum` gives the table's size in bytes. If a file
has no program header table, `e_phnum` holds the value zero.

## e_shentsize

This member holds a section header's size in bytes. A section header is one entry
in the section header table; all entries are the same size.

(0x34 for 32 bit, 0x40 for 64 bit)

## e_shnum

This member holds the number of entries in the section header table. Thus the
product of `e_shentsize` and `e_shnum` gives the section header table's size in
bytes. If a file has no section header table, `e_shnum` holds the value zero

## e_shstrndx

This member holds the section header table index of the entry associated with the
section name string table. If the file has no section name string table, this member
holds the value `SHN_UNDEF`.

Continue to [[pht|Program Header]]
