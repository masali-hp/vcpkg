if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    message(STATUS "Warning: Static building not supported yet. Building dynamic.")
    set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

include(vcpkg_common_functions)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO masali-hp/WPEBackend-rdk
    REF 6d6e1e28a4a593fcf626984e9ebd29ee38b967b7
    SHA512 d9161720ef5575ff49c349d0561f99296f325f453f28121bec6527f7a754d0a59c59af8affa45691601cf32a1660218ce5326e54c2b1d401fbbfe785cf17e434
    HEAD_REF master)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        ${UWP_OPTIONS}
        -DUSE_BACKEND_WINDOWS_EGL=ON
    OPTIONS_DEBUG
        -DENABLE_DEBUG=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/wpebackend-rdk)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/wpebackend-rdk/COPYING ${CURRENT_PACKAGES_DIR}/share/wpebackend-rdk/copyright)

# Allow empty include directory
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

# Allow no import lib
SET(VCPKG_POLICY_DLLS_WITHOUT_LIBS enabled)