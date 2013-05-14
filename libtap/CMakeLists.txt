INCLUDE(Shlomif_Common)

FUNCTION (LIBTAP_TEST_TARGET target)
    ADD_EXECUTABLE( "${target}" "test.c")
    set_target_properties( "${target}" PROPERTIES OUTPUT_NAME "test")
    target_link_libraries( "${target}" "tap")

    SET (check_target "check__${target}")
    ADD_CUSTOM_TARGET(
        "${check_target}"
        "sh" "test.t"
        )

    FOREACH (file_to_copy "test.t" "test.pl")
        CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/${file_to_copy}" "${CMAKE_CURRENT_BINARY_DIR}/${file_to_copy}" COPYONLY)
    ENDFOREACH (file_to_copy)
ENDFUNCTION (LIBTAP_TEST_TARGET target)

cmake_minimum_required(VERSION 2.8)

ADD_SUBDIRECTORY(src)
ADD_SUBDIRECTORY(tests)
ADD_CUSTOM_TARGET(check true DEPENDS check__tests__diag check__tests__fail check__tests__ok__ok check__tests__ok__ok-hash check__tests__ok__ok-numeric check__tests__pass check__tests__plan__no-tests check__tests__plan__no_plan check__tests__plan__not-enough-tests check__tests__plan__sane check__tests__plan__skip_all check__tests__plan__too-many-plans check__tests__plan__too-many-tests check__tests__skip check__tests__todo)

