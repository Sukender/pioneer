# This module defines XXX_FOUND, XXX_INCLUDE_DIRS and XXX_LIBRARIES standard variables
# By Sukender (Benoit NEIL), under the terms of the WTFPL

set(FINDNAME GLEW)

set(CUR_HINTS
	$ENV{${FINDNAME}_DIR}
	$ENV{${FINDNAME}DIR}
	$ENV{${FINDNAME}_PATH}
	$ENV{${FINDNAME}PATH}
)

FIND_PATH(${FINDNAME}_INCLUDE_DIR
	NAMES GL/glew.h gl/glew.h
	HINTS ${CUR_HINTS}
	PATH_SUFFIXES include
)
set(${FINDNAME}_INCLUDE_DIRS ${${FINDNAME}_INCLUDE_DIR})

FIND_LIBRARY(${FINDNAME}_LIBRARY 
	NAMES glew32 glew GLEW
	HINTS ${CUR_HINTS}
	PATH_SUFFIXES lib64 lib
)

FIND_LIBRARY(${FINDNAME}_LIBRARY_DEBUG 
	NAMES glew32d glewd GLEWd
	HINTS ${CUR_HINTS}
	PATH_SUFFIXES lib64 lib
)


IF(${FINDNAME}_LIBRARY)
	IF(${FINDNAME}_LIBRARY_DEBUG)
		SET(${FINDNAME}_LIBRARIES optimized "${${FINDNAME}_LIBRARY}" debug "${${FINDNAME}_LIBRARY_DEBUG}")
	ELSE()
		SET(${FINDNAME}_LIBRARIES "${${FINDNAME}_LIBRARY}")		# Could add "general" keyword, but it is optional
	ENDIF()
ENDIF()

# handle the QUIETLY and REQUIRED arguments and set XXX_FOUND to TRUE if all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(${FINDNAME} DEFAULT_MSG ${FINDNAME}_LIBRARIES ${FINDNAME}_INCLUDE_DIR)
