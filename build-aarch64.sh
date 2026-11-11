#!/bin/bash
set -e

PREFIX="aarch64-linux-gnu-"

CC="${PREFIX}gcc"
LD="${PREFIX}ld"

KERNEL="poly.elf"

OBJECTS=""
INCLUDE_DIR="include" 
BUILD_DIR="build"

mkdir -p "$BUILD_DIR"

while IFS= read -r -d '' file; do
    rel_file="${file#./}"
    obj="$BUILD_DIR/${rel_file%.S}.o"
    mkdir -p "$(dirname "$obj")"
    echo "[S] $file -> $obj"
    $CC -I$INCLUDE_DIR -c -O2 -ffreestanding -nostdlib "$file" -o "$obj"
    OBJECTS="$OBJECTS $obj"
done < <(find . -name "*.S" ! -name "riscv64.S" -print0)

while IFS= read -r -d '' file; do
    rel_file="${file#./}"
    obj="$BUILD_DIR/${rel_file%.c}.o"
    mkdir -p "$(dirname "$obj")"
    echo "[C] $file -> $obj"
    $CC -I$INCLUDE_DIR -c -O2 -ffreestanding -nostdlib "$file" -o "$obj"
    OBJECTS="$OBJECTS $obj"
done < <(find . -name "*.c" -print0)

echo "[LD] Linking files"
$LD -T link-aarch64.ld -o $KERNEL $OBJECTS

echo "[QEMU] $KERNEL"
qemu-system-aarch64 -M virt -cpu cortex-a57 -nographic -kernel $KERNEL