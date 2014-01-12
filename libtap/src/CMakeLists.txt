SET(tap_LIB_SRCS
   tap.c
)

add_library(tap SHARED ${tap_LIB_SRCS})

target_link_libraries(tap)

set_target_properties(tap PROPERTIES VERSION 0.0.0 SOVERSION 0)
install(TARGETS tap DESTINATION "lib${LIB_SUFFIX}")

INSTALL(
    FILES
        "tap.h"
    DESTINATION
        "include"
)
INSTALL_MAN ("tap.3" 3)

