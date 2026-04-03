#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
openwrt_dir="${1:-"$repo_root/openwrt"}"
src_dir="$repo_root/packages/luci-theme-defdo"
dst_dir="$openwrt_dir/package/utils/luci-theme-defdo"

if [[ ! -d "$src_dir" ]]; then
	echo "Theme source not found: $src_dir" >&2
	exit 1
fi

if [[ ! -d "$openwrt_dir" ]]; then
	echo "OpenWrt tree not found: $openwrt_dir" >&2
	exit 1
fi

rm -rf "$dst_dir"
mkdir -p "$(dirname "$dst_dir")"
cp -a "$src_dir" "$dst_dir"

echo "Synced luci-theme-defdo to $dst_dir"
