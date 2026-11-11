#include <core/uart.h>

#define UART0_BASE 0x09000000
#define UART0_DR   (*(volatile unsigned int *)(UART0_BASE + 0x00))

void uart_send_char(char c) {
    UART0_DR = c;
}

void uart_print(const char *s) {
    while (*s) {
        uart_send_char(*s++);
    }
}