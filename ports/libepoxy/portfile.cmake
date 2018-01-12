#if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
#    message(STATUS "Warning: Static building not supported yet. Building dynamic.")
#    set(VCPKG_LIBRARY_LINKAGE dynamic)
#endif()

include(vcpkg_common_functions)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO masali-hp/libepoxy
    REF 56eba0d55334dc36aca20e69c68c54380e6e905e
    SHA512 04f923c361caf6437fac3c657cd4a96ec3287b334b1a360afa144b2d7636a35918ea487de99e20f96c4390f320e41fd3dd1e481053f805551eeede0a252c4f8c
    HEAD_REF master)

if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    SET(EPOXY_LIB_TYPE "SHARED")
else()
    SET(EPOXY_LIB_TYPE "STATIC")
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        ${UWP_OPTIONS}
        -DENABLE_GLX=0
        -DENABLE_EGL=1
        -DENABLE_WGL=1
        -DEPOXY_LIB_TYPE=${EPOXY_LIB_TYPE}
    OPTIONS_DEBUG
        -DENABLE_DEBUG=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/pkgconfig)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share/pkgconfig)

file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libepoxy)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libepoxy/COPYING ${CURRENT_PACKAGES_DIR}/share/libepoxy/copyright)
