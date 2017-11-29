include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO masali-hp/libsoup
    REF cmake-build
    SHA512 71675483d283a17e5f526b278bc3b21dad02051b044701f839a66978c7eb67f24b955113d64cdf5b6c6651bbb759c873063bacff950b60d0244deea2ebee1765
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
