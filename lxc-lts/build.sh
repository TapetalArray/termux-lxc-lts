TERMUX_PKG_HOMEPAGE=https://linuxcontainers.org/
TERMUX_PKG_DESCRIPTION="Linux Containers"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="TapetalArray"
TERMUX_PKG_VERSION=5.0.3
TERMUX_PKG_SRCURL=https://linuxcontainers.org/downloads/lxc/lxc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2693a4c654dcfdafb3aa95c262051d8122afa1b6f5cef1920221ebbdee934d07
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