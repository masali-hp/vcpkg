if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    message(STATUS "Warning: Static building not supported yet. Building dynamic.")
    set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

include(vcpkg_common_functions)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO masali-hp/WPEBackend-rdk
    REF 2f7bec93b28ad8ac60deb002ff7d4ce63182e518
    SHA512 133b4b9dbaf97c446a56d283a551d687634a62147063816040b5014e808edea0981761ebcef44a60b5344362778df6c0824fec4f99298d64df4b7e7e9ea93f1e
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