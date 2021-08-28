#ifndef __DRIVER_API_H__
#define __DRIVER_API_H__
#ifdef __cplusplus
/* clang-format off */
extern "C"
{
/* clang-format on */
#endif /* Start C linkage */

#if defined(CROSS_COMPILING)
#include "driver_interface.h"
#else
#include "driver_interface_stubs.h"
#endif /* #if defined(CROSS_COMPILING) */

#ifdef __cplusplus
/* clang-format off */
}
/* clang-format on */
#endif /* End C linkage */
#endif /* __DRIVER_API_H__ */
