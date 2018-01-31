if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    message(STATUS "Warning: Static building not supported yet. Building dynamic.")
    set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

include(vcpkg_common_functions)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO masali-hp/WPEBackend
    REF c22bdfb27a12f8be158ad04cc03e697941d3a4b9
    SHA512 989527f8af38ab109572eb2593015ae47b1da49aac66932623b8fc68e6325e1fee1ec1dd378e7e2b152539c3d606348a250a7fdbad5d82e09bfebb50752c6da5
    HEAD_REF master)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        ${UWP_OPTIONS}
    OPTIONS_DEBUG
        -DENABLE_DEBUG=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/pkgconfig)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share/pkgconfig)

file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/wpebackend)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/wpebackend/COPYING ${CURRENT_PACKAGES_DIR}/share/wpebackend/copyright)
