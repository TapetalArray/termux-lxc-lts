TERMUX_PKG_HOMEPAGE=https://linuxcontainers.org/
TERMUX_PKG_DESCRIPTION="Linux Containers"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="TapetalArray"
TERMUX_PKG_VERSION=6.0.0
TERMUX_PKG_SRCURL=https://linuxcontainers.org/downloads/lxc/lxc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3f6981c61ff39f9e550a18cf22d6e26792cde5dd34f9d3c93badfeaaee8814b2
TERMUX_PKG_DEPENDS="gnupg, libcap, libseccomp, rsync, wget"
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--prefix=$TERMUX_PREFIX
-Dinit-script=sysvinit
-Druntime-path=$TERMUX_PREFIX/tmp
-Dman=false
--localstatedir=$TERMUX_PREFIX/var
"

termux_step_pre_configure() {
    LDFLAGS="$LDFLAGS -ffunction-sections -fdata-sections -Wl,--gc-sections"
}
