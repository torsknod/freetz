$(call PKG_INIT_BIN, 1.5.6)
$(PKG)_LIB_VERSION:=3.6.3
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=0cf9cb877a5c1508b89844050ff9f45f
$(PKG)_SITE:=http://$(pkg).freedesktop.org/releases/$(pkg)

$(PKG)_BINARY:=$($(PKG)_DIR)/bus/dbus-daemon
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/sbin/dbus-daemon

$(PKG)_LIB_BINARY:=$($(PKG)_DIR)/dbus/.libs/lib$(pkg)-1.so.$($(PKG)_LIB_VERSION)
$(PKG)_LIB_STAGING_BINARY:=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/lib$(pkg)-1.so.$($(PKG)_LIB_VERSION)
$(PKG)_LIB_TARGET_BINARY:=$($(PKG)_TARGET_LIBDIR)/lib$(pkg)-1.so.$($(PKG)_LIB_VERSION)

$(PKG)_DEPENDS_ON := expat

$(PKG)_CONFIGURE_PRE_CMDS += $(call PKG_PREVENT_RPATH_HARDCODING,./configure)

$(PKG)_CONFIGURE_OPTIONS += --with-x=no
$(PKG)_CONFIGURE_OPTIONS += --enable-silent-rules
$(PKG)_CONFIGURE_OPTIONS += --disable-option-checking
$(PKG)_CONFIGURE_OPTIONS += --with-dbus-user=nobody

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY) $($(PKG)_LIB_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(DBUS_DIR)

$($(PKG)_LIB_STAGING_BINARY): $($(PKG)_LIB_BINARY)
	$(SUBMAKE) -C $(DBUS_DIR) \
		DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)" \
		install
	$(PKG_FIX_LIBTOOL_LA) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libdbus-1.la

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$($(PKG)_LIB_TARGET_BINARY): $($(PKG)_LIB_STAGING_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY) $($(PKG)_LIB_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(DBUS_DIR) clean
	 $(RM) -r \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libdbus-1*

$(pkg)-uninstall:
	$(RM) $(DBUS_TARGET_BINARY)
	$(RM) $(DBUS_TARGET_LIBDIR)/libdbus-1*.so*

$(PKG_FINISH)
