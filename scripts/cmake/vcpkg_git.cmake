## # vcpkg_git
##
## Execute a git command.
##
## ## Usage:
## ```cmake
## vcpkg_git(
##     COMMAND clone http://github.com/Microsoft/cpprestsdk cpprestsdk
##     WORKING_DIRECTORY <directory> 
## )
## ```
##
## ## Parameters:
## ### ARGUMENTS
## Specifies the arguments to pass to git.
##
## ### WORKING_DIRECTORY
## The directory to run the command from.
##
function(vcpkg_git ARGUMENTS WORKING_DIRECTORY)

    if(NOT DEFINED ARGUMENTS)
        message(FATAL_ERROR "ARGUMENTS must be specified.")
    endif()

    if(NOT DEFINED WORKING_DIRECTORY)
        message(FATAL_ERROR "WORKING_DIRECTORY must be specified.")
    endif()
    
    if (NOT GIT_EXECUTABLE)
        find_program(GIT_EXECUTABLE
            NAMES git.exe)
    endif()
    if (NOT GIT_EXECUTABLE)
        find_program(GIT_EXECUTABLE
            NAMES git.exe
            HINTS "C:/Program Files" "C:/Program Files (x86)"
            PATH_SUFFIXES Git/cmd
            NO_SYSTEM_ENVIRONMENT_PATH)
    endif()
    if (NOT GIT_EXECUTABLE)
        find_package(Git)
    endif()
    if (NOT GIT_EXECUTABLE)
        message(FATAL_ERROR "Unable to find git executable.")
    endif()

    separate_arguments(GIT_ARGS NATIVE_COMMAND ${ARGUMENTS})
    execute_process(
        COMMAND ${GIT_EXECUTABLE} ${GIT_ARGS}
        OUTPUT_FILE ${WORKING_DIRECTORY}/git-out.log
        ERROR_FILE ${WORKING_DIRECTORY}/git-err.log
        RESULT_VARIABLE error_code
        WORKING_DIRECTORY ${WORKING_DIRECTORY}
    )
    
    file(TO_NATIVE_PATH ${WORKING_DIRECTORY} NATIVE_WORKING_DIRECTORY)
    file(TO_NATIVE_PATH ${WORKING_DIRECTORY}/git-out.log NATIVE_OUT_FILE)
    file(TO_NATIVE_PATH ${WORKING_DIRECTORY}/git-err.log NATIVE_ERR_FILE)
    
    if (NOT "${error_code}" STREQUAL "0")
        message(FATAL_ERROR
            "${NATIVE_WORKING_DIRECTORY}>\n"
            "${GIT_EXECUTABLE} ${ARGUMENTS}\n"
            "Failed.\n"
            "    Exit Code: ${error_code}\n"
            "    See logs for more information:\n"
            "        ${NATIVE_OUT_FILE}\n"
            "        ${NATIVE_ERR_FILE}\n"
        )
    else()
        message(STATUS "git ${ARGUMENTS} ... OK")
        file(REMOVE
            ${WORKING_DIRECTORY}/git-out.log
            ${WORKING_DIRECTORY}/git-err.log
        )
    endif()

endfunction()