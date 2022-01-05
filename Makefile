######################################
# target
######################################
TARGET = io-expander

######################################
# building variables
######################################
# debug build?
DEBUG = 1
# optimization
OPT = --opt-code-size

#######################################
# paths
#######################################
# Source path
SOURCE_DIR = src
SPL_SOURCE_DIR = /usr/src/stm8s_spl
# Build path
BUILD_DIR = build
# SPL Build path
SPL_BUILD_DIR = $(BUILD_DIR)/spl

######################################
# source
######################################
# C sources
LOCAL_SOURCES =  \
main.c

SPL_SOURCES =  \
$(SPL_SOURCE_DIR)/stm8s_gpio.c

#######################################
# binaries
#######################################
CC = sdcc
MKDIR = mkdir -p
STM8FLASH = stm8flash

#######################################
# CFLAGS
#######################################
# mcu
MCU = -mstm8

# C defines
C_DEFS =  \
-DSTM8S103

# C includes
C_INCLUDES =  \
-Iinc \
-I/usr/include/stm8s_spl \
-I/usr/local/share/sdcc/include

# compile gcc flags
CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT)

#######################################
# LDFLAGS
#######################################
LDFLAGS = $(MCU) --out-fmt-ihx

.PHONY: all clean

# default action: build all
all: $(BUILD_DIR)/$(TARGET).ihx

#######################################
# build the application
#######################################
# list of objects
LOCAL_OBJ_FILES = $(LOCAL_SOURCES:.c=.rel)
LOCAL_OBJS = $(patsubst %,$(BUILD_DIR)/%,$(LOCAL_OBJ_FILES))
#LOCAL_OBJS = $(addprefix $(BUILD_DIR)/,$(notdir $(LOCAL_SOURCES:.c=.rel)))
#vpath %.c $(sort $(dir $(LOCAL_SOURCES)))
SPL_OBJ_FILES = $(SPL_SOURCES:.c=.rel)
SPL_OBJS = $(patsubst $(SPL_SOURCE_DIR)/%,$(SPL_BUILD_DIR)/%,$(SPL_OBJ_FILES))

# Link
# @echo "[LD] $(LDFLAGS) $< -o $@"
$(BUILD_DIR)/$(TARGET).ihx: $(LOCAL_OBJS) $(SPL_OBJS)
	$(CC) $(LDFLAGS) $< $(SPL_OBJS) -o $@

# Compile
# @echo "[CC] -c $(CFLAGS) $< -o $@"
$(BUILD_DIR)/%.rel: $(SOURCE_DIR)/%.c
	@$(MKDIR) $(dir $@)
	$(CC) -c $(CFLAGS) $< -o $@

$(SPL_BUILD_DIR)/%.rel: $(SPL_SOURCE_DIR)/%.c
	@$(MKDIR) $(dir $@)
	$(CC) -c $(CFLAGS) $< -o $@

#######################################
# upload
#######################################
upload: $(BUILD_DIR)/$(TARGET).ihx 
	$(STM8FLASH) -c stlinkv2 -p stm8s103f3 -s flash -w $<

#######################################
# clean up
#######################################
clean:
	-rm -fR $(BUILD_DIR)

# *** EOF ***