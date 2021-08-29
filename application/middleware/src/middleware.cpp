#include "middleware.h"
#include "driver_api.h"

MiddlewareInitStatus middleware_init() {
    DI_init();

    // Do other stuff here like pass function pointersr from the
    // driver interface to things like a third-party USB CDC library,
    // Bluetooth stack, initialize a modem, etc...
    //
    // Since the driver interface is used to wrap the actual implmentation
    // of the peripheral, we can replace the target device entirely and
    // minimize the required scope of firmware changes even when a fundamental
    // hardware change is made like swapping modems that use a completely
    // different interface AND different AT commands.

    return MiddlewareInitStatus::OK;
}

/* THIS IS HERE SO THAT WE DONT NEED TO TOUCH CMAKE*/
#define UART_MODEM
//#define USB_MODEM
void middlware_talk_to_modem() {
#if defined(UART_MODEM)
    uint8_t bytes[] = "AT_COMMAND_FOR_MODEM";
    DI_uart_transmit_bytes(bytes, (sizeof(bytes) / sizeof(*bytes)));
#elif defined(USB_MODEM)

    // talk to the modem with USB CDC APIs from the middleware layer

#else
#error NO DRIVER INTERFACE IMPLEMTATION SELECTED FOR middlware_talk_to_modem
#endif /* #if defined(UART_MODEM) */
}
