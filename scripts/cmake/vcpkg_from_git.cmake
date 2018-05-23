include(vcpkg_git)

## # vcpkg_from_git
##
## Clone a project using git. Enables support for `install --head`.
##
## ## Usage:
## ```cmake
## vcpkg_from_git(
##     OUT_SOURCE_PATH <SOURCE_PATH>
##     REPO http://github.com/Microsoft/cpprestsdk
##     [REF <v2.0.0>]
##     [HEAD_REF <master>]
## )
## ```
##
## ## Parameters:
## ### OUT_SOURCE_PATH
## Specifies the out-variable that will contain the extracted location.
##
## This should be set to `SOURCE_PATH` by convention.
##
## ### REPO
## The organization or user and repository on GitHub.
##
## ### REF
## A stable git commit-ish (ideally a tag) that will not change contents. **This should not be a branch.**
##
## For repositories without official releases, this can be set to the full commit id of the current latest master.
##
## If `REF` is specified, `SHA512` must also be specified.
##
## ### HEAD_REF
## The unstable git commit-ish (ideally a branch) to pull for `--head` builds.
##
## For most projects, this should be `master`. The chosen branch should be one that is expected to be always buildable on all supported platforms.
##
## ## Notes:
## At least one of `REF` and `HEAD_REF` must be specified, however it is preferable for both to be present.
##
## This does NOT export the `VCPKG_HEAD_VERSION` variable during head builds.
##
## ## Examples:
##
## * none currently
function(vcpkg_from_git)
    set(oneValueArgs OUT_SOURCE_PATH REPO REF HEAD_REF SERVER)
    set(multipleValuesArgs PATCHES)
    cmake_parse_arguments(_vdud "" "${oneValueArgs}" "${multipleValuesArgs}" ${ARGN})

    if(NOT DEFINED _vdud_OUT_SOURCE_PATH)
        message(FATAL_ERROR "OUT_SOURCE_PATH must be specified.")
    endif()

    if(NOT DEFINED _vdud_REPO)
        message(FATAL_ERROR "The git repository must be specified.")
    endif()

    if(NOT DEFINED _vdud_REF AND NOT DEFINED _vdud_HEAD_REF)
        message(FATAL_ERROR "At least one of REF and HEAD_REF must be specified.")
    endif()

    if(VCPKG_USE_HEAD_VERSION)
        if(NOT DEFINED _vdud_HEAD_REF)
            message(STATUS "Package does not specify HEAD_REF. Falling back to non-HEAD version.")
        else()
            set(_vdud_REF ${_vdud_HEAD_REF})
        endif()
    endif()
    
    if(NOT _vdud_REF)
        message(FATAL_ERROR "Package does not specify REF. It must built using --head.")
    endif()

    set(SOURCE_PATH "${CURRENT_BUILDTREES_DIR}/src/${PORT}")

    if(NOT EXISTS ${CURRENT_BUILDTREES_DIR}/src)
        file(MAKE_DIRECTORY ${CURRENT_BUILDTREES_DIR}/src)
    endif()
            
    if(NOT _VCPKG_NO_DOWNLOADS)
        if(NOT EXISTS ${SOURCE_PATH})
            vcpkg_git("clone ${_vdud_REPO} ${PORT}" "${CURRENT_BUILDTREES_DIR}/src")
        else()
            vcpkg_git("fetch origin" "${SOURCE_PATH}")
        endif()
    endif()
    
    # blow away any current patches
    vcpkg_git("checkout -- ." "${SOURCE_PATH}")
    
    vcpkg_git("checkout ${_vdud_REF}" "${SOURCE_PATH}")
    
    vcpkg_apply_patches(
        SOURCE_PATH ${SOURCE_PATH}
        PATCHES ${_vdud_PATCHES}
    )

    set(${_vdud_OUT_SOURCE_PATH} "${SOURCE_PATH}" PARENT_SCOPE)
endfunction()