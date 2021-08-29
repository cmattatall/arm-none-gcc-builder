#ifndef __MIDDLEWARE_H__
#define __MIDDLEWARE_H__
#ifdef __cplusplus
/* clang-format off */
extern "C"
{
/* clang-format on */
#endif /* Start C linkage */


enum class MiddlewareInitStatus {
    OK,
    ERROR,
    UNKNOWN,
};

MiddlewareInitStatus middleware_init();

void middlware_talk_to_modem();

#ifdef __cplusplus
/* clang-format off */
}
/* clang-format on */
#endif /* End C linkage */
#endif /* __MIDDLEWARE_H__ */
