#!/bin/sh
set -eu

repository_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
submodule_path="$repository_root/UndertaleModTool"
patch_path="$repository_root/patches/undertale-mod-tool-zero-padding-warning.patch"

if [ ! -e "$submodule_path/.git" ]; then
    echo "UndertaleModTool is not initialized. Run git submodule update --init --recursive." >&2
    exit 1
fi
[ -f "$patch_path" ] || { echo "Missing UndertaleModTool patch: $patch_path" >&2; exit 1; }

if git -C "$submodule_path" apply --reverse --check --whitespace=nowarn "$patch_path" >/dev/null 2>&1; then
    echo "UndertaleModTool zero-padding patch is already applied."
    exit 0
fi
git -C "$submodule_path" apply --check --whitespace=error-all "$patch_path"
git -C "$submodule_path" apply --whitespace=nowarn "$patch_path"
echo "Applied UndertaleModTool zero-padding patch."
