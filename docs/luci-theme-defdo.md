# luci-theme-defdo

`luci-theme-defdo` now lives as a standalone package in:

`packages/luci-theme-defdo`

It is no longer treated as a hand-edited package living permanently inside the local OpenWrt buildroot.

## Local Build

Requirements:

- local OpenWrt tree at `openwrt/`
- GitHub CLI only if you want to publish a release

Sync the standalone package into the OpenWrt tree and build it:

```bash
./scripts/build_luci_theme_defdo.sh
```

That script does this:

1. copies `packages/luci-theme-defdo` to `openwrt/package/utils/luci-theme-defdo`
2. runs `make defconfig`
3. builds `package/utils/luci-theme-defdo` with `CONFIG_PACKAGE_luci-theme-defdo=m`

Expected output package:

```text
openwrt/bin/packages/<arch>/base/luci-theme-defdo_1.0.1-r1_all.ipk
```

Versioning follows the standard OpenWrt package flow:

- `PKG_VERSION`: semantic package version, currently `1.0.1`
- `PKG_RELEASE`: package revision for the same version, currently `1` and emitted by OpenWrt as `r1` in the final package filename

That means:

- functional theme changes should usually bump `PKG_VERSION`
- packaging-only fixes should usually bump `PKG_RELEASE`

## Manual Sync Only

If you only want to refresh the package inside the buildroot:

```bash
./scripts/sync_luci_theme_defdo.sh
```

You can also point it at a different OpenWrt tree:

```bash
./scripts/sync_luci_theme_defdo.sh /path/to/openwrt
```

## GitHub Release

If `gh auth status` works, create or update a release with the latest built package:

```bash
./scripts/release_luci_theme_defdo.sh
```

You can provide a fixed tag:

```bash
./scripts/release_luci_theme_defdo.sh v1.0.1-r1
```

What it does:

1. builds the package if no `.ipk` exists yet
2. generates a `.sha256` file
3. defaults the release tag to `v<ipk-version>` using the actual built artifact version, e.g. `v1.0.1-r1`
4. creates a release or uploads over an existing one using `gh release`

## GitHub Actions

Workflow:

`/.github/workflows/luci-theme-defdo-release.yml`

Use the manual `workflow_dispatch` trigger. It clones an upstream OpenWrt tree, syncs the standalone package into it, builds the `.ipk`, uploads it as an artifact, and publishes it to a GitHub release.
