#! /usr/bin/env bash
RISCV_GCC=riscv32-unknown-elf-gcc
RISCV_LD=riscv32-unknown-elf-ld
RISCV_OBJCPY=riscv32-unknown-elf-objcopy
$RISCV_GCC -c  -g -mabi=ilp32 -march=rv32i  -O0  exo1.S -o  exo1.o
$RISCV_LD  --build-id=none -Bstatic -T firmware_riscv.ld -Map firmware.map exo1.o -o firmware.elf
$RISCV_OBJCPY -j .text -O verilog --verilog-data-width 4   firmware.elf imem.hex 
$RISCV_OBJCPY -j .rodata -j .data --change-section-address .data-0x10000 --change-section-address .rodata-0x10000 -O verilog --verilog-data-width 4   firmware.elf dmem.hex
