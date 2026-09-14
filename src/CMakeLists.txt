# Additional CMake configuration file for building the xchange library from
# source
#
# To invoke simply configure the cmake build in the smax-clib root directory.
#
# Author: Attila Kovacs


set(C_SOURCES
  smax.c
  smax-control.c
  smax-easy.c
  smax-lazy.c
  smax-messages.c
  smax-meta.c
  smax-queue.c
  smax-resilient.c
  smax-sub.c
  smax-tls.c
  smax-util.c
  procname.c
)

add_library(core ${C_SOURCES})
add_library(smax::core ALIAS core)

set_target_properties(core PROPERTIES
    VERSION ${PROJECT_VERSION}
    SOVERSION ${PROJECT_VERSION_MAJOR}
    OUTPUT_NAME smax
)

target_include_directories(core PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${xchange_INCLUDE_DIRS}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Link with math libs as necessary
target_link_libraries(core PUBLIC xchange::core redisx::core ${MATHLIB} ${WINSOCK2} Threads::Threads)

if(ENABLE_TLS)
    target_compile_definitions(core PRIVATE WITH_TLS=1)
    target_link_libraries(core PUBLIC OpenSSL::SSL)
    if(BUILD_CLI)
       target_link_libraries(core PRIVATE OpenSSL::SSL)
    endif()
endif()

if(BUILD_CLI)
  add_executable(smaxValue smaxValue.c pass.c)
  target_link_libraries(smaxValue PRIVATE core ${POPT_LIBRARY} ${READLINE_LIBRARY} ${BSD_LIBRARY})
  add_test(NAME check-smaxValue COMMAND ${CMAKE_BINARY_DIR}/bin/smaxValue --help)
  
  add_executable(smaxWrite smaxWrite.c pass.c)
  target_link_libraries(smaxWrite PRIVATE core ${POPT_LIBRARY} ${READLINE_LIBRARY} ${BSD_LIBRARY})
  add_test(NAME check-smaxWrite COMMAND ${CMAKE_BINARY_DIR}/bin/smaxWrite --help)
endif()



# Uncomment below to enforce the C99 standard
#set_property(TARGET core PROPERTY C_STANDARD 99)



  


