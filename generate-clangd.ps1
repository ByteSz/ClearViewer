$ErrorActionPreference = "Stop"

# Root directory
$root = Get-Location

# Find all "include" folders recursively, convert to absolute paths, and remove duplicates
$includeDirs = Get-ChildItem -Path $root -Recurse -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -ieq "include" } |
    ForEach-Object { try { (Resolve-Path $_.FullName).ProviderPath } catch { $null } } |
    Where-Object { $_ -ne $null } |
    Sort-Object -Unique

# Initialize .clangd
$out = @()
$out += "CompileFlags:"
$out += "  Add:"
$out += '    # Compilation options'
$out += '    - "--std=c++20"'
$out += '    - "--target=x86_64-w64-mingw32"'
$out += '    - "-ferror-limit=1024"'

# Add include directories
$out += '    # Include directories'
foreach ($dir in $includeDirs) {
    $out += "    - -I$dir"  # absolute path, no quotes
}

# Diagnostics settings
$out += 'Diagnostics:'
$out += '  MissingIncludes: Strict'
$out += '  UnusedIncludes: Strict'

# Write .clangd file
$out | Set-Content -Encoding UTF8 ".clangd"

# Summary
Write-Host "Generated .clangd with $($includeDirs.Count) unique include directories."
