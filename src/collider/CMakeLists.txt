set(TARGETNAME "collider")

set( ${TARGETNAME}_H
	"BVHTree.h"
	"collider.h"
	"CollisionContact.h"
	"CollisionSpace.h"
	"Geom.h"
	"GeomTree.h"
)
set( ${TARGETNAME}_SRC
	"BVHTree.cpp"
	"CollisionSpace.cpp"
	"Geom.cpp"
	"GeomTree.cpp"
)

# IF (${PROJECT_NAME}_USE_PRECOMPILED_HEADERS)
	# LIST(APPEND ${TARGETNAME}_H "${PCH_DEFAULT_H}")
	# LIST(APPEND ${TARGETNAME}_SRC "${PCH_DEFAULT_CPP}")
# ENDIF()

# Setup dependencies
SETUP_DEFAULT_DEPENDENCIES_LIST(DEPENDENCIES_NAMES)

LINK_DIRS_WITH_VARIABLES(${TARGETNAME} ${DEPENDENCIES_NAMES})
add_library("${TARGETNAME}" STATIC ${${TARGETNAME}_H} ${${TARGETNAME}_SRC})
LINK_WITH_VARIABLES(${TARGETNAME} ${DEPENDENCIES_NAMES})

MAKE_ENUM_DEPEND(${TARGETNAME})
#target_link_libraries(${TARGETNAME} LUA OOLUA)

# IF (${PROJECT_NAME}_USE_PRECOMPILED_HEADERS)
	# SET_USE_PRECOMPILED_HEADER(${TARGETNAME} ${PCH_DEFAULT_H} ${PCH_DEFAULT_CPP})
# ENDIF()
