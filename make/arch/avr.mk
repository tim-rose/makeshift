#
# AVR --Definitions for Atmel AVR.
#
# Remarks:
# The AVR setup is a "cross" compile setup, so we need to redefine the
# compiler toolchain
#
C_ARCH_DEFS = -mmcu=atmega1280 -I/opt/local/avr/include -L/opt/local/avr/lib
CC	= avr-gcc
