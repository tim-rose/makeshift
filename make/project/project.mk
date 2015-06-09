#
# PROJECT.MK	--per-project customisations
#
# Remarks:
# The project include file defines overall customisations for existing
# rules. This is the "no-project" project, which contains some default
# settings to consider as a template.
#
# Set the environment variable PROJECT to your project name, and create
# the file /usr/local/include/project/$PROJECT.mk.
#
# Consider using these flags too, if/when they're available...
#    -Wuseless-cast
#    -Wzero-as-null-pointer-constant
#    -Wlogical-op
#    -Wnoexcept
#     -Wstrict-null-sentinel
#
# See Also:
# http://stackoverflow.com/questions/5088460/flags-to-enable-thorough-and-verbose-g-warnings/9862800#9862800
#

PROJECT.C_DEFS =
PROJECT.C++_DEFS =

PROJECT.CFLAGS = -std=c99 -O
PROJECT.C_WARN_FLAGS = -pedantic -Wall -Wextra \
    -Waggregate-return  -Wcast-align  -Wcast-qual -Wdisabled-optimization \
    -Wformat=2  -Wimplicit -Wmissing-declarations  -Wmissing-include-dirs \
    -Wmissing-prototypes -Wnested-externs  -Wpointer-arith \
    -Wredundant-decls -Wshadow  -Wsign-conversion \
    -Wstack-protector -Wstrict-overflow=5  -Wstrict-prototypes \
    -Wswitch-enum -Wswitch-default  -Wundef  -Wwrite-strings

PROJECT.CXXFLAGS = -std=c++0x -O
PROJECT.C++_WARN_FLAGS = $(PROJECT.C_WARN_FLAGS) \
    -Wctor-dtor-privacy  -Weffc++  -Winit-self -Wsign-promo \
    -Wno-variadic-macros -Wold-style-cast  -Woverloaded-virtual
