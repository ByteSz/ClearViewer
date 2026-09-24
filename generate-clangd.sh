#!/usr/bin/env bash
set -euo pipefail

# Root directory
ROOT="$(pwd)"

# Find all "include" directories recursively, convert to absolute paths, and remove duplicates
mapfile -t INCLUDE_DIRS < <(
    find "$ROOT" -type d -iname "include" -print0 | xargs -0 -n1 realpath | sort -u
)

# Initialize .clangd
OUT=()
OUT+=("CompileFlags:")
OUT+=("  Add:")
OUT+=("    # Compilation options")
OUT+=("    - \"--std=c++20\"")
OUT+=("    - \"--target=x86_64-w64-mingw32\"")
OUT+=("    - \"-ferror-limit=1024\"")

# Add include directories
OUT+=("    # Include directories")
for dir in "${INCLUDE_DIRS[@]}"; do
    OUT+=("    - -I$dir")
done

# Diagnostics settings
OUT+=("Diagnostics:")
OUT+=("  MissingIncludes: Strict")
OUT+=("  UnusedIncludes: Strict")

# Write .clangd file
printf "%s\n" "${OUT[@]}" > .clangd

echo "Generated .clangd with ${#INCLUDE_DIRS[@]} unique include directories."
