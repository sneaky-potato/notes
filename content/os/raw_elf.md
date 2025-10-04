# Raw ELF

Please check [[elf_header|ELF Header]] and [[pht|Program Header]] formats.

## Raw bytes

Example of 32 bit ELF that just exits with a status code of 42

```bash title="exit32.dmp"
#  -------------- ELF HEADER --------------
                # all numbers are in base 16
                # 00 number of bytes to be used in the ELF
7F 45 4C 46     # 04 e_ident[EI_MAG]: ELF magic bytes
01              # 05 e_ident[EI_CLASS]: 1=32-bit, 2=64-bit, for 32 bit addresses would be 4 byte long
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

#  ------------ PROGRAM HEADER ------------

01 00 00 00     # 38 p_type: segment type; 1: loadable

54 00 00 00     # 3C p_offset: file offset where segment begins
54 80 04 08     # 40 p_vaddr: virtual address of segment in memory (x86: 08048054)
    
00 00 00 00     # 44 p_paddr: physical address of segment, unspecified by 386 supplement
0C 00 00 00     # 48 p_filesz: size in bytes of the segment in the file image ############

0C 00 00 00     # 4C p_memsz: size in bytes of the segment in memory; p_filesz <= p_memsz
05 00 00 00     # 50 p_flags: segment-dependent flags (1: X, 2: W, 4: R)

00 10 00 00     # 54 p_align: 1000 for x86

#  ------------ PROGRAM SEGMENT ------------

B8 01 00 00 00  # 59 eax <- 1 (exit)
BB 2A 00 00 00  # 5E ebx <- 2A (param)
CD 80           # 60 syscall >> int 80
```

Similar example of 64 bit ELF that just exits with a status code of 42

```bash title="exit64.dmp"
#  -------------- ELF HEADER --------------
                           # all numbers are in base 16
                           # 00 number of bytes to be used in the ELF
7F 45 4C 46                # 04 e_ident[EI_MAG]: ELF magic bytes
02                         # 05 e_ident[EI_CLASS]: 1=32-bit, 2=64-bit, for 32 bit addresses would be 4 byte long
   01                      # 06 e_ident[EI_DATA]: 1=little-endian, 2=big=endian
      01                   # 07 e_ident[EI_VERSION]: ELF header version
         00                # 08 e_ident[EI_OSABI]: Target OS ABI; should be 0 for System V
00                         # 09 e_ident[EI_ABIVERSION]: ABI version; 0 is ok for Linux
   00 00 00                # 0C e_identpEI_PAD]: unused, should be 0 
00 00 00 00                # 10

02 00                      # 12 e_type: object file type; 1=relocable, 2=executable
      3E 00                # 14 e_machine: instruction set architecture; 03=x86, 3E=amd64(x86-64)
01 00 00 00                # 18 e_version: ELF identification version; must be 1
78 00 40 00 00 00 00 00    # 20 e_entry: memory address of entry point (where process starts)
40 00 00 00 00 00 00 00    # 28 e_phoff: file offset where program headers begin: start immediately after ELF header

00 00 00 00 00 00 00 00    # 30 e_shoff: file offset where section headers begin

00 00 00 00                # 34 e_flags: 0 for x86

40 00                      # 36 e_ehsize: size of this header (34: 32-bit, 40: 64-bit)
      38 00                # 38 e_phentsize: size of each program header (20: 32-bit, 38: 64-bit)
01 00                      # 3A e_phnum: #program headers
      40 00                # 3C e_shentsize: size of each section header (28: 32-bit, 40: 64-bit)

00 00                      # 3E e_shnum: #section headers
      00 00                # 40 e_shstrndx: index of section header containing section names

#  ------------ PROGRAM HEADER ------------

01 00 00 00                # 44 p_type: segment type; 1: loadable
05 00 00 00                # 48 p_flags: segment-dependent flags (1: X, 2: W, 4: R)

78 00 00 00 00 00 00 00    # 50 p_offset: ELF header size + this program header size
78 00 40 00 00 00 00 00    # 58 p_vaddr: 0x40000 + offset)
00 00 00 00 00 00 00 00    # 60 p_paddr: irrelevant for x86_64

10 00 00 00 00 00 00 00    # 68 p_filesz:  (just count the bytes for your machine instructions)

10 00 00 00 00 00 00 00    # 70 p_memsz: (if this is greater than file size, then it zeros out the extra memory)

00 10 00 00 00 00 00 00    # 78 p_align: 1000 for x86

#  ------------ PROGRAM SEGMENT -----------

48 C7 C0 3C 00 00 00       # 7F mov rax, 60 (0x3C)
48 C7 C7 2A 00 00 00       # 86 mov rdi, 42 (0x2A)
0F 05                      # 88 syscall >> int 80
```

## How to get binary

```bash
$ cut -d'#' -f1 <exit32.dmp | xxd -p -r > exit32
$ chmod +x exit32
$ ./exit32
$ echo $?
42
```

