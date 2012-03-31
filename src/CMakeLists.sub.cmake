# This is the common part for "pioneer" and "modelviewer" executables


IF (${PROJECT_NAME}_USE_PRECOMPILED_HEADERS)
	LIST(APPEND ${TARGETNAME}_H_OTHER "${PCH_DEFAULT_H}")
	LIST(APPEND ${TARGETNAME}_SRC_OTHER "${PCH_DEFAULT_CPP}")
ENDIF()

# Add and group sources (except "OTHER")
SET (GROUP_NAME_HEADERS "Header files")
SET (GROUP_NAME_SOURCE "Source Files")
SET (TARGET_H )
SET (TARGET_SRC )
foreach(group ${GROUP_LIST})
	list(APPEND TARGET_H ${${TARGETNAME}_H_${group}})
	list(APPEND TARGET_SRC ${${TARGETNAME}_SRC_${group}})
	source_group("${GROUP_NAME_HEADERS}\\${group}" FILES ${${TARGETNAME}_H_${group}})
	source_group("${GROUP_NAME_SOURCE}\\${group}" FILES ${${TARGETNAME}_SRC_${group}})
endforeach()

# Now adding "other" elements (ie. source files that don't go elsewhere)
list(APPEND TARGET_H ${${TARGETNAME}_H_OTHER})
list(APPEND TARGET_SRC ${${TARGETNAME}_SRC_OTHER})
source_group("${GROUP_NAME_HEADERS}" FILES ${${TARGETNAME}_H_OTHER})
source_group("${GROUP_NAME_SOURCE}" FILES ${${TARGETNAME}_SRC_OTHER})


SET(PLATFORM_SPECIFIC_CONTROL )
IF(WIN32 AND NOT ${PROJECT_NAME}_FORCE_CONSOLE_APPS)
	SET(PLATFORM_SPECIFIC_CONTROL WIN32)
ENDIF()

# Setup dependencies
SET(DEPENDENCIES_NAMES )

IF(UNIX)
	LIST(APPEND DEPENDENCIES_NAMES MATH_LIBRARY X11)
	ADD_DEFINITIONS( -D${PROJECT_NAME}_USE_X11 )
ENDIF()

LIST(APPEND DEPENDENCIES_NAMES OPENGL)
LIST(APPEND DEPENDENCIES_NAMES GLEW)
LIST(APPEND DEPENDENCIES_NAMES FREETYPE SDL SDLIMAGE PNG)
LIST(APPEND DEPENDENCIES_NAMES OGG VORBIS VORBISFILE)
LIST(APPEND DEPENDENCIES_NAMES SIGCPP)

#LIST(APPEND DEPENDENCIES_NAMES Boost_DATE_TIME Boost_FILESYSTEM Boost_PROGRAM_OPTIONS Boost_SERIALIZATION Boost_SYSTEM Boost_REGEX Boost_LOCALE Boost_THREAD)
#LIST(APPEND DEPENDENCIES_NAMES ICU)		# For boost.regex & boost.locale

LINK_DIRS_WITH_VARIABLES(${TARGETNAME} ${DEPENDENCIES_NAMES})
add_executable(${TARGETNAME} ${PLATFORM_SPECIFIC_CONTROL} ${TARGET_SRC} ${TARGET_H} ${SETUP_${PROJECT_NAME}_EXE_RESSOURCES})
LINK_WITH_VARIABLES(${TARGETNAME} ${DEPENDENCIES_NAMES})

target_link_libraries(${TARGETNAME} LUA OOLUA)

# ADD_DEFINITIONS( 
	# -DBOOST_ENABLE_ASSERT_HANDLER
	# -DBOOST_ALL_DYN_LINK	# Tell boost to use dynamic libraries
	# -DBOOST_ALL_NO_LIB		# No boost auto link
# )

IF (${PROJECT_NAME}_USE_PRECOMPILED_HEADERS)
	SET_USE_PRECOMPILED_HEADER(${TARGETNAME} ${PCH_DEFAULT_H} ${PCH_DEFAULT_CPP})
ENDIF()

IF(MSVC)
	# Ugly workaround to remove the "/debug" or "/release" in each output
	SET_TARGET_PROPERTIES(${LIB_NAME} PROPERTIES PREFIX "../")
	SET_TARGET_PROPERTIES(${LIB_NAME} PROPERTIES IMPORT_PREFIX "../")
ENDIF()

SET_TARGET_PROPERTIES(${LIB_NAME} PROPERTIES VERSION ${${PROJECT_NAME}_VERSION})

#############################################################
# PACKAGE
#INCLUDE(ModuleInstall)		# Installs binary in '/bin'
set(DESTINATION_DIR ".")
INSTALL(
	TARGETS ${TARGETNAME}
	RUNTIME DESTINATION "${DESTINATION_DIR}" COMPONENT mainComponent
)

IF(${PROJECT_NAME}_INSTALL_DEPENDENCIES)
	# Install direct dependencies
	FOREACH(CURCONFIG ${CMAKE_CONFIGURATION_TYPES})
		GET_TARGET_PROPERTY(LOCATION_${CURCONFIG} "${TARGETNAME}" LOCATION_${CURCONFIG})
	ENDFOREACH()
	CONFIGURE_FILE( 
		"${CMAKE_SOURCE_DIR}/dependencies.cmake.in"
		"${CMAKE_CURRENT_BINARY_DIR}/dependencies.${TARGETNAME}.cmake"
		@ONLY
	)
	INCLUDE(InstallRequiredSystemLibraries REQUIRED)
	INSTALL(SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/dependencies.${TARGETNAME}.cmake")
ENDIF()

#############################################################
