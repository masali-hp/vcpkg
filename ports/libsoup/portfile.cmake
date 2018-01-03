include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO masali-hp/libsoup
    REF cmake-build
    SHA512 08625013ba1c816f64cd02a456e0318423996181d0bfe2660d560cbc54838b5f3a4142831e3aaa16a34c0cf5cdfe34e2ebaef483b66bdf1859a759fffd13b3f6
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
