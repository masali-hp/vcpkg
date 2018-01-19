include(vcpkg_common_functions)

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    message(STATUS "ANGLE currently only supports being built as a dynamic library")
    set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

if(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    message(FATAL_ERROR "ANGLE currently only supports being built for desktop")
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO google/angle
    REF 0dc97810e5e4ed49d4a6c31d071550e618e9e25e
    SHA512 9abee138f3d262f6853c1de93f5a98c56e601070ffefeba8b55982aead487ca273ebd0c63ed23aebdfd6879799c493f4f6ba00d9730b0cbdf92c7afafe4ae9c8
    HEAD_REF master
)
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES ${CMAKE_CURRENT_LIST_DIR}/001-fix-uwp.patch
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/commit.h DESTINATION ${SOURCE_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS_DEBUG -DDISABLE_INSTALL_HEADERS=1
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH share/unofficial-angle)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/angle ${CURRENT_PACKAGES_DIR}/share/unofficial-angle)

vcpkg_copy_pdbs()

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/angle RENAME copyright)
