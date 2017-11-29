include(vcpkg_common_functions)

vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO https://github.com/masali-hp/libsoup
    REF cmake-build
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DGLIB_TOOLS=${CMAKE_PREFIX_PATH}/tools/glib
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()

file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libsoup)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libsoup/COPYING ${CURRENT_PACKAGES_DIR}/share/libsoup/copyright)

vcpkg_copy_pdbs()
