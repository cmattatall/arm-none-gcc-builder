#include "catch2/catch.hpp"
#include "middleware.h"
#include "middleware_init_status.h"

SCENARIO("We are initializing the middleware layer") {
    GIVEN("We have not initialized the middleware layer") {
        WHEN("We initialize the middleware layer") {
            MiddlewareInitStatus initStatus = MiddlewareInitStatus::UNKNOWN;
            THEN("I expect the initialization to succeed") {
                initStatus = middleware_init();
                REQUIRE(initStatus == MiddlewareInitStatus::OK);
            }
        }
    }
}