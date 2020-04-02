#
# DEFAULT.MK	--Default per-project customisations.
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
#    -Wstrict-null-sentinel
#
# See Also:
# http://stackoverflow.com/questions/5088460/flags-to-enable-thorough-and-verbose-g-warnings/9862800#9862800
#
PROJECT.CFLAGS = -std=c17 -O -DVERSION='"$(VERSION)"' -DBUILD='"$(BUILD)"'
PROJECT.C_WARN_FLAGS = @$(DEVKIT_HOME)/etc/gcc.conf
PROJECT.C_DEFS =

PROJECT.CXXFLAGS = -std=c++14 -O -DVERSION='"$(VERSION)"' -DBUILD="'$(BUILD)'"
PROJECT.C++_WARN_FLAGS =  @$(DEVKIT_HOME)/etc/g++.conf
PROJECT.C++_DEFS =
