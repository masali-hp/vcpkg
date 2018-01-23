if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    message(STATUS "Warning: Static building not supported yet. Building dynamic.")
    set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

include(vcpkg_common_functions)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO masali-hp/WPEBackend-rdk
    REF 66f12407bbbcb477d99ed9059794499a0ced3d28
    SHA512 85fce7276bdca411f9572ac8ba0b26dbdd87b9e7c7a2f7a4863a648928a9e06d5f39c8e7c72ae20d51c37aa2804b3d722ed1a958f8fc745cfc2116ec804eef6b
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