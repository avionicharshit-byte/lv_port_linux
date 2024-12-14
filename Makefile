# Makefile

# Compiler
CC              ?= clang

# LVGL Directory
LVGL_DIR        ?= ./lvgl

# Compiler Warnings and Flags
WARNINGS        := -Wall -Wshadow -Wundef -Wmissing-prototypes -Wextra -Wno-unused-function -Wpointer-arith \
                   -fno-strict-aliasing -Wuninitialized -Wno-unused-parameter -Wtype-limits \
                   -Wformat-security -Wno-sign-compare -std=gnu99

CFLAGS          ?= -O3 -g0 -I$(LVGL_DIR)/ -I/opt/homebrew/include -I/opt/homebrew/include/SDL2 $(WARNINGS)
LDFLAGS         ?= -L/opt/homebrew/lib -lSDL2 -lSDL2_image -lSDL2_ttf -lSDL2_gfx -framework Cocoa

# Build Directories
BUILD_DIR       = ./build
BUILD_OBJ_DIR   = $(BUILD_DIR)/obj
BUILD_BIN_DIR   = $(BUILD_DIR)/bin

# Install Directories
prefix          ?= /usr
bindir          ?= $(prefix)/bin

# Collect the files to compile
MAINSRC         = ./main.c
include $(LVGL_DIR)/lvgl.mk

# Object files
AOBJS           = $(ASRCS:$(LVGL_PATH)/%.S=$(BUILD_OBJ_DIR)/%.o)
COBJS           = $(CSRCS:$(LVGL_PATH)/%.c=$(BUILD_OBJ_DIR)/%.o)
MAINOBJ         = $(MAINSRC:./%.c=$(BUILD_OBJ_DIR)/%.o)
OBJS            = $(AOBJS) $(COBJS) $(MAINOBJ)

# Rules
all: default

$(BUILD_OBJ_DIR)/%.o: $(LVGL_PATH)/%.c
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "CC $<"

$(BUILD_OBJ_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "CC $<"

$(BUILD_OBJ_DIR)/%.o: $(LVGL_PATH)/%.S
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "AS $<"

default: $(OBJS)
	@mkdir -p $(BUILD_BIN_DIR)
	$(CC) -o $(BUILD_BIN_DIR)/main $(OBJS) $(LDFLAGS)

clean: 
	rm -rf $(BUILD_DIR)

install:
	install -d $(DESTDIR)$(bindir)
	install $(BUILD_BIN_DIR)/main $(DESTDIR)$(bindir)

uninstall:
	$(RM) -r $(addprefix $(DESTDIR)$(bindir)/, main)
