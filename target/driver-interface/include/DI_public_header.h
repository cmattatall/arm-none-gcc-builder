#ifndef __DRIVER_INTERFACE_PUBLIC_HEADER_H__
#define __DRIVER_INTERFACE_PUBLIC_HEADER_H__
#ifdef __cplusplus
/* clang-format off */
extern "C"
{
/* clang-format on */
#endif /* Start C linkage */

#include <stdint.h>

int DI_uart_transmit_bytes(uint8_t *buf, uint16_t *buflen);

int DI_init();

#ifdef __cplusplus
/* clang-format off */
}
/* clang-format on */
#endif /* End C linkage */
#endif /* __DRIVER_INTERFACE_PUBLIC_HEADER_H__ */
