$(call PKG_INIT_BIN, 0.3.3)
$(PKG)_SOURCE:=slurm-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=e68d09202b835c644f7f6b7f070f29a2
$(PKG)_SITE:=http://www.wormulon.net/slurm

$(PKG)_BINARY:=$($(PKG)_DIR)/slurm
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/slurm

$(PKG)_DEPENDS_ON += ncurses

# touch configure.in to prevent aclocal.m4 & configure from being regenerated
$(PKG)_CONFIGURE_PRE_CMDS += touch -t 200001010000.00 ./configure.in;

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(SLURM_DIR)

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(SLURM_DIR) clean
	$(RM) $(SLURM_DIR)/.configured

$(pkg)-uninstall:
	$(RM) $(SLURM_TARGET_BINARY)

$(PKG_FINISH)
