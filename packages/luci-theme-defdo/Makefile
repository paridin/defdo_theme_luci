include $(TOPDIR)/rules.mk

PKG_NAME:=luci-theme-defdo
PKG_RELEASE:=1
PKG_LICENSE:=Apache-2.0
PKG_MAINTAINER:=paridin
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-theme-defdo
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=4. Themes
  TITLE:=defdo LuCI theme
  DEPENDS:=+luci-base
  PKGARCH:=all
endef

define Package/luci-theme-defdo/description
 Complete Defdo LuCI theme with dedicated templates, static assets and default theme registration.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile
endef

define Package/luci-theme-defdo/postinst
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] || {
	rm -f /tmp/luci-indexcache /tmp/luci-modulecache
	/etc/init.d/uhttpd reload >/dev/null 2>&1 || true
}
exit 0
endef

define Package/luci-theme-defdo/postrm
#!/bin/sh
[ -n "$$IPKG_INSTROOT" ] || {
	uci -q delete luci.themes.Defdo
	[ "$$(uci -q get luci.main.mediaurlbase)" = "/luci-static/defdo" ] && \
		uci -q delete luci.main.mediaurlbase
	uci commit luci
}
exit 0
endef

define Package/luci-theme-defdo/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./root/etc/uci-defaults/30_luci-theme-defdo \
		$(1)/etc/uci-defaults/30_luci-theme-defdo

	$(INSTALL_DIR) $(1)/usr/share/ucode/luci/template/themes/defdo
	$(INSTALL_DATA) ./ucode/template/themes/defdo/header.ut \
		$(1)/usr/share/ucode/luci/template/themes/defdo/header.ut
	$(INSTALL_DATA) ./ucode/template/themes/defdo/footer.ut \
		$(1)/usr/share/ucode/luci/template/themes/defdo/footer.ut
	$(INSTALL_DATA) ./ucode/template/themes/defdo/sysauth.ut \
		$(1)/usr/share/ucode/luci/template/themes/defdo/sysauth.ut

	$(INSTALL_DIR) $(1)/www/luci-static/defdo
	$(INSTALL_DATA) ./htdocs/luci-static/defdo/cascade.css \
		$(1)/www/luci-static/defdo/cascade.css
	$(INSTALL_DATA) ./htdocs/luci-static/defdo/mobile.css \
		$(1)/www/luci-static/defdo/mobile.css
	$(INSTALL_DATA) ./htdocs/luci-static/defdo/defdo.css \
		$(1)/www/luci-static/defdo/defdo.css
	$(INSTALL_DATA) ./htdocs/luci-static/defdo/logo.svg \
		$(1)/www/luci-static/defdo/logo.svg
	$(INSTALL_DATA) ./htdocs/luci-static/defdo/logo_48.png \
		$(1)/www/luci-static/defdo/logo_48.png
	$(INSTALL_DATA) ./htdocs/luci-static/defdo/defdo-favicon.ico \
		$(1)/www/luci-static/defdo/defdo-favicon.ico
	$(INSTALL_DATA) ./htdocs/luci-static/defdo/defdo-favicon-16x16.png \
		$(1)/www/luci-static/defdo/defdo-favicon-16x16.png
	$(INSTALL_DATA) ./htdocs/luci-static/defdo/defdo-favicon-32x32.png \
		$(1)/www/luci-static/defdo/defdo-favicon-32x32.png
	$(INSTALL_DATA) ./htdocs/luci-static/defdo/defdo-apple-touch-icon.png \
		$(1)/www/luci-static/defdo/defdo-apple-touch-icon.png
	$(INSTALL_DATA) ./htdocs/luci-static/defdo/defdo-logo-main.png \
		$(1)/www/luci-static/defdo/defdo-logo-main.png
	$(INSTALL_DATA) ./htdocs/luci-static/defdo/defdo-logo-light.png \
		$(1)/www/luci-static/defdo/defdo-logo-light.png

	$(INSTALL_DIR) $(1)/www/luci-static/resources
	$(INSTALL_DATA) ./htdocs/luci-static/resources/menu-bootstrap.js \
		$(1)/www/luci-static/resources/menu-bootstrap.js

	$(INSTALL_DIR) $(1)/www/luci-static/resources/view/bootstrap
	$(INSTALL_DATA) ./htdocs/luci-static/resources/view/bootstrap/sysauth.js \
		$(1)/www/luci-static/resources/view/bootstrap/sysauth.js
endef

$(eval $(call BuildPackage,luci-theme-defdo))
