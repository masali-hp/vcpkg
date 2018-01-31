if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    message(STATUS "Warning: Static building not supported yet. Building dynamic.")
    set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

include(vcpkg_common_functions)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO masali-hp/WPEBackend-rdk
    REF 2565a8e5fe0c98f93818b6ae04a13338114523a7
    SHA512 5c80140c2529aa61bf6371126722a5d997fb42e77158fe96bc05a0928e16fcc6f7e6ac4f73496b433104a0d60c1d1a49925a76e2a65cbdbf2e9b4c67e93a144a
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