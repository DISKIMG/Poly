.section .text.boot

.global _start
_start:
    la sp, stack_top

    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop

    call _ini

.L_hang:
    wfi
    j .L_hang
