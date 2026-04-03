#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
openwrt_dir="${OPENWRT_DIR:-"$repo_root/openwrt"}"
repo="${GH_REPO:-}"
tag="${1:-}"

if [[ -z "$repo" ]]; then
	repo="$(gh repo view --json nameWithOwner -q .nameWithOwner)"
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

ipk_version="$(basename "$ipk" | sed -E 's/^luci-theme-defdo_([^_]+)_all\.ipk$/\1/')"

if [[ -z "$tag" ]]; then
	tag="v${ipk_version}"
fi

sha_file="$ipk.sha256"
sha256sum "$ipk" > "$sha_file"

notes_file="$(mktemp)"
cat > "$notes_file" <<EOF
Release for luci-theme-defdo

Package:
- $(basename "$ipk")

Package version:
- ${ipk_version}

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
