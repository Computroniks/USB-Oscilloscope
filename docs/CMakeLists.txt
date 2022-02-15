find_package(Doxygen REQUIRED doxygen)
find_program(LATEX pdflatex)

set(DOXYGEN_GENERATE_HTML YES)
set(DOXYGEN_GENERATE_MAN YES)
if(LATEX)
    set(DOXYGEN_GENERATE_LATEX YES)
    set(LATEX_COMMAND "make")
    message("-- Found LATEX: ${LATEX}")
else()
    set(DOXYGEN_GENERATE_LATEX NO)
    set(LATEX_COMMAND "")
    message("-- LATEX not found. LATEX documentation will not be generated")
endif()
set(DOXYGEN_PROJECT_BRIEF "Simple USB oscilloscope based on ATTiny 85")

doxygen_add_docs(
    doxygen
    "${PROJECT_SOURCE_DIR}/include"
    "${PROJECT_SOURCE_DIR}/src"
    COMMENT "Generate HTML documentation"
)
add_custom_target(
    docs

    COMMAND
        ${LATEX_COMMAND}

    WORKING_DIRECTORY ./latex/

    DEPENDS doxygen

)