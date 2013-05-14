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

INCLUDE(InstallRequiredSystemLibraries)

SET(CPACK_SOURCE_IGNORE_FILES
    "/(build|B/)"
    "/_CPack_Packages/"
    "/CMakeFiles/"
    "/.deps/"
    "${base_with_ver}(-Source|-Linux)/"
    "${base_with_ver}.tar\\\\.(gz|bz2|Z|lzma|xz)$"
    "\\\\.o$"
    "~$"
)

SET(CPACK_PACKAGE_NAME "libtap")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "libtap - TAP-emitting library for C testing")
SET(CPACK_PACKAGE_VENDOR "Shlomi Fish")
SET(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/README")
SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/COPYING")
SET(CPACK_PACKAGE_VERSION_MAJOR "1")
SET(CPACK_PACKAGE_VERSION_MINOR "2")
SET(CPACK_PACKAGE_VERSION_PATCH "0")
SET(CPACK_SOURCE_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")
SET(CPACK_PACKAGE_INSTALL_DIRECTORY "${CPACK_PACKAGE_DESCRIPTION_SUMMARY} ${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")
IF(WIN32 AND NOT UNIX)
  # There is a bug in NSI that does not handle full unix paths properly. Make
  # sure there is at least one set of four (4) backlasshes.
  SET(CPACK_PACKAGE_ICON "${CMake_SOURCE_DIR}/Utilities/Release\\\\InstallIcon.bmp")
  SET(CPACK_NSIS_INSTALLED_ICON_NAME "bin\\\\MyExecutable.exe")
  SET(CPACK_NSIS_DISPLAY_NAME "${CPACK_PACKAGE_INSTALL_DIRECTORY} My Famous Project")
  SET (myurl "http:\\\\\\\\www.shlomifish.org\\\\open-source\\\\projects\\\\libtap\\\\")
  SET(CPACK_NSIS_HELP_LINK "${myurl}")
  SET(CPACK_NSIS_URL_INFO_ABOUT "${myurl}")
  SET(CPACK_NSIS_CONTACT "shlomif@shlomifish.org")
  SET(CPACK_NSIS_MODIFY_PATH ON)
ELSE(WIN32 AND NOT UNIX)
  SET(CPACK_STRIP_FILES)
  SET(CPACK_SOURCE_STRIP_FILES "")
ENDIF(WIN32 AND NOT UNIX)
SET(CPACK_PACKAGE_EXECUTABLES)

INCLUDE(CPack)

ADD_SUBDIRECTORY(src)
ADD_SUBDIRECTORY(tests)
ADD_CUSTOM_TARGET(check true DEPENDS check__tests__diag check__tests__fail check__tests__ok__ok check__tests__ok__ok-hash check__tests__ok__ok-numeric check__tests__pass check__tests__plan__no-tests check__tests__plan__no_plan check__tests__plan__not-enough-tests check__tests__plan__sane check__tests__plan__skip_all check__tests__plan__too-many-plans check__tests__plan__too-many-tests check__tests__skip check__tests__todo)

