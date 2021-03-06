# Extension of the standard FindXXX.cmake
#   Adds XXX_LIBRARIES, XXX_INCLUDE_DIRS
# By Sukender (Benoit NEIL), under the terms of the WTFPL

macro(FIND_ADAPTATPOR FINDNAME FINDVARIABLE)
	INCLUDE("${CMAKE_ROOT}/Modules/Find${FINDNAME}.cmake")

	if( NOT ${FINDVARIABLE}_LIBRARIES AND ${FINDVARIABLE}_LIBRARY )
		SET(${FINDVARIABLE}_LIBRARIES ${${FINDVARIABLE}_LIBRARY})
	endif()
	if( NOT ${FINDVARIABLE}_INCLUDE_DIRS AND ${FINDVARIABLE}_INCLUDE_DIR )
		SET(${FINDVARIABLE}_INCLUDE_DIRS ${${FINDVARIABLE}_INCLUDE_DIR})
	endif()
endmacro()
