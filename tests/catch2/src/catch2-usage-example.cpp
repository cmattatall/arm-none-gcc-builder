/**
 * @file test1.cpp
 * @author Carl Mattatall (carl.mattatall@rimot.io)
 * @brief Example file to demonstrate how to use catch2 for unit tests
 * @version 0.1
 * @date 2021-08-29
 *
 * @copyright Copyright (c) 2021 Carl Mattatall
 *
 */

#include "catch2/catch.hpp"

SCENARIO("A scenario under which we are performing a unit test") {
    GIVEN("Precondition set 1") {
        WHEN("Event 1 occurrs") {
            THEN("I expect something to happen") {
                REQUIRE(true);
            }
        }
        AND_WHEN("EVENT 2 Occurrs") {
            THEN("I expect something else to happen") {
                REQUIRE(true);
            }
        }
    }

    GIVEN("Precondition set 2") {
        WHEN("Event 1 occurrs") {
            THEN("I expect something to happen") {
                REQUIRE(true);
            }
        }
        AND_WHEN("EVENT 2 Occurrs") {
            THEN("I expect something else to happen") {
                REQUIRE(true);
            }
        }
    }
}