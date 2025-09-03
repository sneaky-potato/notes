# Extensible and Linkable Format

Used as:
- Executable
- Shared Library
- Object file

It has two main things
- Segments: relevant at runtime, example `data`, `code`
- Sections: relevant at link time

---

## Structure

- ELF Header: stores locations of *PHT* and *SHT*
- Program Header Table: how and where to load ELF file’s data into memory
- Section Header Table: optional map of data to assist in debugging
- Data: all of binary’s data, *PHT* and *SHT* point to this section

[[elf_header|ELF Header]]

[[pht|Program Header]]

[[raw_elf|32 and 64 bit ELF files]]

## 64 bit ELF

```bash
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
