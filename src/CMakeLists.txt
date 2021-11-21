find_package(FLEX)
find_package(BISON)

IF(WIN32)
    set(BISON_EXECUTABLE C:\\win_flex_bison3\\win_bison)
    set(BISON_INCLUDE_DIR C:\\win_flex_bison3)
    set(FLEX_EXECUTABLE C:\\win_flex_bison3\\win_flex)
ELSEIF(UNIX)
    IF(NOT(FLEX_FOUND AND BISON_FOUND))
        message(FATAL_ERROR "No Flex or Bison Found.")
    ENDIF()
ENDIF()


ADD_CUSTOM_COMMAND(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/tm_yylex.yy.cc
    COMMAND ${FLEX_EXECUTABLE}
        --outfile=${CMAKE_CURRENT_BINARY_DIR}/tm_yylex.yy.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/tm_yylex.l
    COMMENT "Generating tm_yylex"
)
ADD_CUSTOM_COMMAND(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/tm_parser.tab.cc
        COMMAND ${BISON_EXECUTABLE}
            --defines=${CMAKE_CURRENT_BINARY_DIR}/tm_parser.tab.hh
            --output=${CMAKE_CURRENT_BINARY_DIR}/tm_parser.tab.cc
            ${CMAKE_CURRENT_SOURCE_DIR}/tm_parser.yy
        COMMENT "Generating tm_parser"
    )

ADD_EXECUTABLE(fleson
        ${CMAKE_CURRENT_SOURCE_DIR}/quad.h
        ${CMAKE_CURRENT_SOURCE_DIR}/slice.h
        ${CMAKE_CURRENT_SOURCE_DIR}/tm_driver.h
        ${CMAKE_CURRENT_SOURCE_DIR}/tm_lexer.h
        ${CMAKE_CURRENT_SOURCE_DIR}/type_node.h
        ${CMAKE_CURRENT_SOURCE_DIR}/var.h
        ${CMAKE_CURRENT_SOURCE_DIR}/main.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/tm_driver.cpp
        ${CMAKE_CURRENT_BINARY_DIR}/tm_yylex.yy.cc
        ${CMAKE_CURRENT_BINARY_DIR}/tm_parser.tab.cc
)

target_include_directories(fleson
    PRIVATE
        ${CMAKE_CURRENT_BINARY_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${BISON_INCLUDE_DIR}
)