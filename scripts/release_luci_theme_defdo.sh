#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
openwrt_dir="${OPENWRT_DIR:-"$repo_root/openwrt"}"
repo="${GH_REPO:-}"
tag="${1:-}"
package_makefile="$repo_root/packages/luci-theme-defdo/Makefile"

package_version="$(sed -n 's/^PKG_VERSION:=//p' "$package_makefile" | head -n 1)"
package_release="$(sed -n 's/^PKG_RELEASE:=//p' "$package_makefile" | head -n 1)"

if [[ -z "$repo" ]]; then
	repo="$(gh repo view --json nameWithOwner -q .nameWithOwner)"
fi

if [[ -z "$tag" ]]; then
	tag="v${package_version}-${package_release}"
fi

ipk="$(find "$openwrt_dir/bin/packages" -type f -name 'luci-theme-defdo_*_all.ipk' | sort | tail -n 1 || true)"

if [[ -z "$ipk" ]]; then
	"$repo_root/scripts/build_luci_theme_defdo.sh"
	ipk="$(find "$openwrt_dir/bin/packages" -type f -name 'luci-theme-defdo_*_all.ipk' | sort | tail -n 1 || true)"
fi

if [[ -z "$ipk" ]]; then
	echo "No luci-theme-defdo .ipk found after build" >&2
	exit 1
fi

sha_file="$ipk.sha256"
sha256sum "$ipk" > "$sha_file"

notes_file="$(mktemp)"
cat > "$notes_file" <<EOF
Release for luci-theme-defdo

Package:
- $(basename "$ipk")

Package version:
- ${package_version}-${package_release}

Source:
- $(git -C "$repo_root" rev-parse --short HEAD)
EOF

if gh release view "$tag" --repo "$repo" >/dev/null 2>&1; then
	gh release upload "$tag" "$ipk" "$sha_file" --repo "$repo" --clobber
else
	gh release create "$tag" "$ipk" "$sha_file" \
		--repo "$repo" \
		--title "$tag" \
		--notes-file "$notes_file"
fi

rm -f "$notes_file"

echo "Published $(basename "$ipk") to $repo release $tag"
