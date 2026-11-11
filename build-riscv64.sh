#!/bin/bash
set -e

PREFIX="riscv64-linux-gnu-"

CC="${PREFIX}gcc"
LD="${PREFIX}ld"

KERNEL="poly-riscv64.elf"
OBJECTS=""

while IFS= read -r -d '' file; do
    obj="${file%.S}.o"
    echo "[S] $file -> $obj"
    $CC -march=rv64g -mabi=lp64 -c -O2 -ffreestanding -nostdlib "$file" -o "$obj"
    OBJECTS="$OBJECTS $obj"
done < <(find . -name "*.S" ! -name "aarch64.S" -print0)

while IFS= read -r -d '' file; do
    obj="${file%.c}.o"
    echo "[C] $file -> $obj"
    $CC -march=rv64g -mabi=lp64 -c -O2 -ffreestanding -nostdlib "$file" -o "$obj"
    OBJECTS="$OBJECTS $obj"
done < <(find . -name "*.c" -print0)

echo "[LD] Linking files"
$LD -T link-riscv64.ld -o $KERNEL $OBJECTS

echo "[QEMU] $KERNEL"
qemu-system-riscv64 -M virt -cpu rv64 -nographic -bios none -kernel $KERNEL