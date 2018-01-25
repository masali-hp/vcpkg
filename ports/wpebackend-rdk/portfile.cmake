if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    message(STATUS "Warning: Static building not supported yet. Building dynamic.")
    set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

include(vcpkg_common_functions)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO masali-hp/WPEBackend-rdk
    REF 2a590a01c954fd8bcb6a6383fa6c62a10adfbf86
    SHA512 e53f83301e4c80291f4d050a9875669f3f4930590ec97a7b1b67f47b326624257bf682b9ae897455b4f97c92347290ac1c58cb77e254faa90d2d7e5d5469d99e
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