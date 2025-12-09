OS_NAME = KDev
BUILD_DIR = build
SRC_DIR = kernel

DISK_IMG = $(BUILD_DIR)/$(OS_NAME).img

CC = gcc
AS = nasm
LD = ld

CFLAGS = -m32 -ffreestanding -O2 -c -I$(SRC_DIR) -I$(SRC_DIR)/arch/x86/gdt
ASFLAGS = -f elf32
LDFLAGS = -m elf_i386 -T linker.ld

LIMINE_DATADIR = /usr/share/limine

ALL_C_SOURCES = $(shell find $(SRC_DIR) -name "*.c")
ALL_ASM_SOURCES = $(shell find $(SRC_DIR) -name "*.asm")

START_SOURCE = $(SRC_DIR)/start.asm
OTHER_ASM_SOURCES = $(filter-out $(START_SOURCE), $(ALL_ASM_SOURCES))

OBJ = $(BUILD_DIR)/$(SRC_DIR)/start.o \
      $(patsubst $(SRC_DIR)/%.asm, $(BUILD_DIR)/$(SRC_DIR)/%.o, $(OTHER_ASM_SOURCES)) \
      $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/$(SRC_DIR)/%.o, $(ALL_C_SOURCES))

all: $(DISK_IMG)

$(BUILD_DIR)/$(SRC_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	@echo "COMPILING $@"
	@$(CC) $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(SRC_DIR)/%.o: $(SRC_DIR)/%.asm
	@mkdir -p $(dir $@)
	@echo "ASSEMBLING $@"
	@$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/$(OS_NAME).bin: $(OBJ)
	@echo "LINKING $@"
	@$(LD) $(LDFLAGS) -o $@ $(OBJ)

$(DISK_IMG): $(BUILD_DIR)/$(OS_NAME).bin limine.conf
	@echo "BUILDING DISK IMAGE $@"
	@mkdir -p $(BUILD_DIR)

	@dd if=/dev/zero of=$(DISK_IMG) bs=1M count=64 2>/dev/null

	@parted -s $(DISK_IMG) mklabel msdos
	@parted -s $(DISK_IMG) mkpart primary fat32 1MiB 100%
	@parted -s $(DISK_IMG) set 1 boot on

	@mkfs.fat -F 32 -n "KDEV_OS" -h 2048 --offset 2048 $(DISK_IMG) >/dev/null

	@mmd -i $(DISK_IMG)@@1M ::/limine

	@mcopy -i $(DISK_IMG)@@1M $(BUILD_DIR)/$(OS_NAME).bin ::/KDev.bin

	@mcopy -i $(DISK_IMG)@@1M limine.conf ::/limine.conf
	@mcopy -i $(DISK_IMG)@@1M $(LIMINE_DATADIR)/limine-bios.sys ::/limine-bios.sys

	@limine bios-install $(DISK_IMG)

run: $(DISK_IMG)
	qemu-system-x86_64 -drive format=raw,file=$(DISK_IMG) -serial stdio

clean:
	@rm -rf $(BUILD_DIR)

.PHONY: all run clean
