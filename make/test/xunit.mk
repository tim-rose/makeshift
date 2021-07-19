#
# Support for the xunit framework (C#) from a nuget repository
# Install in /usr/local/include/test/
#

nuget_package_dir ?= $(HOME)/nuget

dotnet_framework ?= 4_5_2
MONO_FRAMEWORK ?= /usr/lib/mono/$(shell echo ${dotnet_framework} | sed s/_/./g)-api/Facades

xunit_dotnet_version ?= net$(shell echo ${dotnet_framework} | sed s/_//g)
xunit_test_runner ?= $(nuget_package_dir)/xunit.runner.console.2.4.1/tools/${xunit_dotnet_version}/xunit.console.exe
xunit_packages = \
    $(nuget_package_dir)/xunit.runner.console.2.4.1/tools/${xunit_dotnet_version}/xunit.runner.utility.${xunit_dotnet_version}  \
    $(nuget_package_dir)/xunit.runner.console.2.4.1/tools/${xunit_dotnet_version}/xunit.runner.reporters.${xunit_dotnet_version}  \
    $(nuget_package_dir)/xunit.runner.console.2.4.1/tools/${xunit_dotnet_version}/xunit.abstractions \
    $(nuget_package_dir)/xunit.extensibility.execution.2.4.1/lib/netstandard1.1/xunit.execution.dotnet \
    $(nuget_package_dir)/xunit.extensibility.core.2.4.1/lib/netstandard1.1/xunit.core \
    $(nuget_package_dir)/xunit.assert.2.4.1/lib/netstandard1.1/xunit.assert  \
    $(MONO_FRAMEWORK)/System.Runtime

xunit_dll = $(xunit_packages:%=%.dll)
xunit_base_dll = $(notdir ${xunit_dll})
xunit_local_dll = $(xunit_base_dll:%=${archdir}/%)
space=" "
XUNIT_PATH=$(subst ${space},:,$(dir ${xunit_packages}))
VARIANT.CS_REFS = $(xunit_local_dll:%=/r:%)

# /home/geoff/nuget/xunit.extensibility.execution.2.4.1/lib/net452/xunit.execution.desktop.dll
# if needed, change the remove command according to your system

build: build-xunit

build-xunit: $(xunit_local_dll) 

test: test-xunit

test-xunit: build
	$(MONO) ${xunit_test_runner} $(archdir)/${TARGET}

info-xunit:
	@echo xunit_dll=$(xunit_dll)
	@echo xunit_base_dll=$(xunit_base_dll)
	@echo xunit_local_dll=$(xunit_local_dll)
	@echo XUNIT_PATH=$(XUNIT_PATH)
	@echo MONO_FRAMEWORK=$(MONO_FRAMEWORK)
	@echo xunit_dotnet_version=$(xunit_dotnet_version)
	@echo VARIANT.CS_REFS=$(VARIANT.CS_REFS)

clean: clean-xunit

clean-xunit:
	@$(RM) $(XUNIT_LOCAL_LIBS)

$(archdir)/%.dll: %.dll
	@echo $(INSTALL_PROGRAM) $? $(archdir)/$(notdir $@)
	$(INSTALL_PROGRAM) $? $(archdir)/$(notdir $@)

