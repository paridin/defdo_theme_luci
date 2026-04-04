# defdo_theme_luci

Standalone repository for the `luci-theme-defdo` OpenWrt LuCI theme.

This repository keeps the theme source independent from any specific local OpenWrt checkout and includes:

- the standalone package source in `packages/luci-theme-defdo`
- helper scripts to sync the package into an OpenWrt tree
- a local build script for the `.ipk`
- a release script using `gh`
- a GitHub Actions workflow that builds and publishes the package
- installation documentation for end users

## Repository Layout

```text
packages/luci-theme-defdo
scripts/sync_luci_theme_defdo.sh
scripts/build_luci_theme_defdo.sh
scripts/release_luci_theme_defdo.sh
docs/luci-theme-defdo.md
docs/install.md
.github/workflows/luci-theme-defdo-release.yml
```

## Install on OpenWrt

If you already have an OpenWrt device with LuCI, use the latest GitHub release:

- `https://github.com/paridin/defdo_theme_luci/releases/latest`

Installation options:

- `opkg` devices: install the `.ipk` directly
- `apk` devices: install by extracting the package contents
- manual verification: check `/usr/share/luci-theme-defdo/VERSION`

Full instructions:

- [docs/install.md](docs/install.md)

## Local Build

If you have an OpenWrt checkout at `./openwrt`:

```bash
./scripts/build_luci_theme_defdo.sh
```

Or point to a different tree:

```bash
OPENWRT_DIR=/path/to/openwrt ./scripts/build_luci_theme_defdo.sh
```

Expected output:

```text
openwrt/bin/packages/<arch>/base/luci-theme-defdo_1.0.1-r1_all.ipk
```

Versioning uses standard OpenWrt package fields:

- `PKG_VERSION=1.0.1`
- `PKG_RELEASE=1` which OpenWrt emits as `r1` in the final `.ipk` filename

## Publish a Release

If `gh auth status` works:

```bash
./scripts/release_luci_theme_defdo.sh
```

Or with an explicit tag:

```bash
./scripts/release_luci_theme_defdo.sh v1.0.1-r1
```

## GitHub Actions

Use the manual workflow `luci-theme-defdo-release` to:

1. clone OpenWrt
2. sync the standalone package into the buildroot
3. compile `luci-theme-defdo`
4. upload the `.ipk` as a workflow artifact
5. publish it to a GitHub release

More detail:

- [docs/luci-theme-defdo.md](docs/luci-theme-defdo.md)
- [docs/install.md](docs/install.md)
