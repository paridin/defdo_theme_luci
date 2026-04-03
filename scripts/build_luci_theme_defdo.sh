#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
openwrt_dir="${OPENWRT_DIR:-"$repo_root/openwrt"}"
verbose="${V:-s}"

"$repo_root/scripts/sync_luci_theme_defdo.sh" "$openwrt_dir"

cd "$openwrt_dir"
make defconfig
make package/utils/luci-theme-defdo/compile CONFIG_PACKAGE_luci-theme-defdo=m V="$verbose"

find "$openwrt_dir/bin/packages" -type f -name 'luci-theme-defdo_*_all.ipk' | sort
