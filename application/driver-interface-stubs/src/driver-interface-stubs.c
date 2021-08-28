#include <stdio.h>

#include "driver_interface_stubs.h"

int DI_uart_transmit_bytes(uint8_t *buf, uint16_t buflen) {
    printf("invoked %s\n", __func__);
}

int DI_init() {
    printf("invoked %s\n", __func__);
}