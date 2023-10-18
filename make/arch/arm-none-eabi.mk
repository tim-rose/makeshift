#
# ARM --Definitions for ARM.
#
AS = $(CC) -x assembler-with-cpp
ARCH.CFLAGS = -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard \
    -fdata-sections -ffunction-sections
ARCH.ASFLAGS = $(ARCH.CFLAGS)
