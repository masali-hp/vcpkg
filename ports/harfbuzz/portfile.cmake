include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/harfbuzz-1.6.3)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/behdad/harfbuzz/releases/download/1.6.3/harfbuzz-1.6.3.tar.bz2"
    FILENAME "harfbuzz-1.6.3.tar.bz2"
    SHA512 37d1a161d9074e9898d9ef6cca6dffffc725005828d700744553b0145373b69bcd3b08f507d49f4c2e05850d9275a54f15983356c547c86e5e3c202cc7cbfbe8
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES "${CMAKE_CURRENT_LIST_DIR}/0001-fix-uwp-build.patch"
)

if(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm" OR VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    SET(HAVE_GLIB "OFF")
    SET(BUILTIN_UCDN "ON")
else()
    SET(HAVE_GLIB "ON")
    SET(BUILTIN_UCDN "OFF")
endif()

# NOTE: once ICU vcpkg build works, we shouldn't need to manually specify paths for ICU.
# Harfbuzz debug build finds release icuuc lib.  Manually specifying ICU_LIBRARY fixes that.

if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    SET(ICU_LIB_DEBUG ${CURRENT_PACKAGES_DIR}/../../../icu/lib/icuucd.lib)
    SET(ICU_LIB_RELEASE ${CURRENT_PACKAGES_DIR}/../../../icu/lib/icuuc.lib)
else ()
    SET(ICU_LIB_DEBUG ${CURRENT_PACKAGES_DIR}/../../../icu/lib64/icuucd.lib)
    SET(ICU_LIB_RELEASE ${CURRENT_PACKAGES_DIR}/../../../icu/lib64/icuuc.lib)
endif ()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DHB_HAVE_FREETYPE=ON
        -DHB_HAVE_GLIB=${HAVE_GLIB}
        -DHB_BUILTIN_UCDN=${BUILTIN_UCDN}
        -DHB_HAVE_ICU=ON
        -DICU_INCLUDE_DIR=${CURRENT_PACKAGES_DIR}/../../../icu/include
    OPTIONS_RELEASE
        -DICU_LIBRARY=${ICU_LIB_RELEASE}
    OPTIONS_DEBUG
        -DICU_LIBRARY=${ICU_LIB_DEBUG}
        -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/harfbuzz)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/harfbuzz/COPYING ${CURRENT_PACKAGES_DIR}/share/harfbuzz/copyright)
