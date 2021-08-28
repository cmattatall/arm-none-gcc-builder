#include "driver_interface.h"
#include "DI_private_header.h"

#if defined(STM32)
#include "stm32f4xx_hal.h"
#warning USING STM32HAL IMPLEMENTATION FOR DRIVER INTERFACE
#elif defined(TI_CHIP)
#warning USING TEXAS INSTRUMENTS DRIVERLIB IMPLEMENTATION FOR DRIVER INTERFACE
#else
#error NO PREPROCESSOR DEFINITION TO SELECT VENDOR APIs FOR DI_uart_transmit_bytes
#endif /* #if defined(STM32) */

void DI_private_helper_function() {
  // doing some helper function stuff
}

int DI_uart_transmit_bytes(uint8_t *buf, uint16_t buflen) {
#if defined(STM32)
#if defined(STM32F411xE)
  // HAL_UART_Transmit( /* ... args ... */);
#elif defined(STM32F411xE)

#else
#error NO STM32 DEVICE SPECIFIC IN DI_uart_transmit_bytes
#endif /* STM DEVICE FAMILY SELECT */

#elif defined(TI_CHIP)
#warning USING TEXAS INSTRUMENTS DRIVERLIB IMPLEMENTATION FOR DRIVER INTERFACE
#else
#error NO PREPROCESSOR DEFINITION TO SELECT VENDOR APIs FOR DI_uart_transmit_bytes
#endif /* #if defined(STM32) */
}

int DI_init() {
  // do stuff to initialize the abstract peripheral driver layer

  DI_private_helper_function();
}
