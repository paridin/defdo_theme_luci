# Install `luci-theme-defdo`

This guide covers the easiest ways to install `luci-theme-defdo` on an existing OpenWrt device with LuCI already present.

## Prerequisites

- LuCI is already installed on the router
- you can reach the router shell through SSH or serial
- you know whether the device uses `opkg` or `apk`

Check package manager availability:

```sh
which opkg
which apk
```

## Get the Latest Release

GitHub releases:

- `https://github.com/paridin/defdo_theme_luci/releases/latest`

Expected package naming:

```text
luci-theme-defdo_<version>_all.ipk
```

Example:

```text
luci-theme-defdo_1.0.1-r1_all.ipk
```

## Option 1: Install on `opkg`-based OpenWrt

Download the package to `/tmp`:

```sh
cd /tmp
wget -O /tmp/luci-theme-defdo_1.0.1-r1_all.ipk \
  https://github.com/paridin/defdo_theme_luci/releases/download/v1.0.1-r1/luci-theme-defdo_1.0.1-r1_all.ipk
```

Install it:

```sh
opkg install /tmp/luci-theme-defdo_1.0.1-r1_all.ipk
```

Refresh LuCI:

```sh
rm -f /tmp/luci-indexcache /tmp/luci-modulecache
/etc/init.d/uhttpd restart
```

## Option 2: Install on `apk`-based OpenWrt

Some recent OpenWrt builds use `apk` and do not install `.ipk` packages directly. In that case, extract the package contents manually.

Download the package:

```sh
cd /tmp
wget -O /tmp/luci-theme-defdo_1.0.1-r1_all.ipk \
  https://github.com/paridin/defdo_theme_luci/releases/download/v1.0.1-r1/luci-theme-defdo_1.0.1-r1_all.ipk
```

Extract and install:

```sh
cd /tmp
rm -f /tmp/data.tar.gz /tmp/control.tar.gz /tmp/debian-binary
tar -xzf /tmp/luci-theme-defdo_1.0.1-r1_all.ipk
tar -xzf /tmp/data.tar.gz -C /
sh /etc/uci-defaults/30_luci-theme-defdo
rm -f /tmp/luci-indexcache /tmp/luci-modulecache
/etc/init.d/uhttpd restart
```

## Verify the Installed Version

The package installs a version marker:

```sh
cat /usr/share/luci-theme-defdo/VERSION
```

Expected output:

```text
1.0.1-r1
```

## Verify Theme Activation

Check the active LuCI media path:

```sh
uci get luci.main.mediaurlbase
```

Expected output:

```text
/luci-static/defdo
```

## Quick UI Validation

Check that the updated menu styling is present:

```sh
grep -n "box-shadow: inset 0 -2px 0" /www/luci-static/defdo/defdo.css
grep -n "rgba(var(--color-primary), 0.18)" /www/luci-static/defdo/defdo.css
```

Then force a browser refresh:

- `Ctrl+F5`
- private window
- or clear the browser cache for the router IP

## Notes

- The package is architecture-independent (`all`) because it ships theme templates and static assets.
- LuCI compatibility still depends on the target OpenWrt/LuCI version.
- If you maintain your own firmware tree, building from source is still the cleanest integration path.
