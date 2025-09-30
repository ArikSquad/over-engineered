#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

NASM=${NASM:-nasm}
CC=${CC:-gcc}
CFLAGS=${CFLAGS:--g -O0 -Wall -Wextra}
LDFLAGS=${LDFLAGS:-}
SAN=${SAN:-}

if ! command -v "$NASM" >/dev/null 2>&1; then
	echo "Error: nasm is required" >&2
	exit 1
fi

asm_obj=allocator.o
exe=a.out

echo "[1/3] Assembling allocator.asm -> $asm_obj"
"$NASM" -f elf64 -g -F dwarf allocator.asm -o "$asm_obj"

echo "[2/3] Compiling and linking test.c + allocator.o -> $exe"
"$CC" $CFLAGS test.c "$asm_obj" $SAN $LDFLAGS -o "$exe"

echo "[3/3] Running $exe"
if [[ "${VALGRIND:-}" != "" && -x "$(command -v valgrind || true)" ]]; then
	echo "Running under valgrind..."
	valgrind --quiet --error-exitcode=99 --leak-check=full --show-leak-kinds=all ./$exe
else
	./$exe
fi

echo "Done."

