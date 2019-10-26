.org 0x0
    .global _start
_start:
    li a0, 1
    li a1, 1
_addLoop:
    add a0, a0, a1
    j _addLoop
