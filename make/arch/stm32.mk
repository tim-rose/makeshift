#
# STM32.MK --Macros and definitions for ARM/STM32 architectures
#
ARMCC_FLAGS = --cpu=Cortex-M4.fp \
    --list --asm --interleave \
    --asm_dir=$(archdir) --list_dir=$(archdir) \
    --md --depend_dir=$(archdir) --depend_format=unix \
    --signed_chars --no_rtti \
    --diag_remark=450,667 \
    -IC:/Keil/ARM/RV31/INC

ARCH.CXXFLAGS = -c --cpp $(ARMCC_FLAGS)
ARCH.CFLAGS = -c $(ARMCC_FLAGS)

ARCH.C_DEFS = -DARCH_ARM -DCPU_STM32
ARCH.C++_DEFS = -DARCH_ARM -DCPU_STM32
