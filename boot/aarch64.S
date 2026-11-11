.section .text.boot

.global _start
_start:
    mrs x0, CurrentEL
    lsr x0, x0, #2

    cmp x0, #1
    b.eq 2f

    ldr x1, =(1 << 31)
    msr hcr_el2, x1

    mov x1, #0x3c5
    msr spsr_el2, x1

    adr x1, 2f
    msr elr_el2, x1

    eret

2:
    ldr x0, =stack_top
    mov sp, x0

    bl _ini

.L_hang:
    wfe
    b .L_hang

.section .bss
.align 4
stack_bottom:
    .space 4096
stack_top:
