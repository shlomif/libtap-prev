SET(tap_LIB_SRCS
   tap.c
)

add_library(tap SHARED ${tap_LIB_SRCS})

target_link_libraries(tap)

set_target_properties(tap PROPERTIES VERSION 4.2.0 SOVERSION 4)
install(TARGETS tap DESTINATION lib)

INSTALL(
    FILES
        "tap.h"
    DESTINATION
        "include"
)
INSTALL_MAN ("tap.3" 3)

