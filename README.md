# Termux LXC

LXC LTS ported for Termux

# Build

```bash
# Clone this repo
git clone https://github.com/TapetalArray/termux-lxc-lts

# Setup Termux Packages
git clone https://github.com/termux/termux-packages
cd ./termux-packages
# Archlinux
./scripts/setup-archlinux.sh
# Ubuntu
./scripts/setup-ubuntu.sh
# Android SDK
./scripts/setup-android-sdk.sh
cd ..

# Copy build configuration and patches
cp ./termux-lxc-lts/lxc-lts ./termux-packages/packages

# Build
./build-package.sh -i -a aarch64 lxc-lts
```

# Usage

You can refer to [this](https://gist.github.com/lateautumn233/939be0528a2cc34af66864bead58e68a) (Chinese)
```bash
# Install dependencies
pkg upg
pkg i x11-repo -y
pkg i tsu pulseaudio termux-nightly -y

# Start pulseaudio
pulseaudio --start \
    --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" \
    --exit-idle-time=-1

# Mount cgroup
for cg in blkio cpu cpuacct cpuset devices freezer memory; do
   if [ ! -d "/sys/fs/cgroup/${cg}" ]; then
       sudo mkdir -p "/sys/fs/cgroup/${cg}"
   fi

   if ! sudo mountpoint -q "/sys/fs/cgroup/${cg}"; then
       sudo mount -t cgroup -o "${cg}" cgroup "/sys/fs/cgroup/${cg}" || true
   fi
done

# or
sudo mount -t tmpfs -o mode=755 tmpfs /sys/fs/cgroup
sudo mkdir -p /sys/fs/cgroup/devices
sudo mount -t cgroup -o devices cgroup /sys/fs/cgroup/devices
sudo mkdir -p /sys/fs/cgroup/systemd /sys/fs/cgroup/freezer
sudo mount -t cgroup cgroup -o none,name=systemd /sys/fs/cgroup/systemd
sudo mount -t cgroup cgroup -o none,name=freezer /sys/fs/cgroup/freezer

# For systemd-binfmt
sudo mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc

# Configure Network
sed -i 's/lxc\.net\.0\.type = empty/lxc.net.0.type = none/g' $PREFIX/etc/lxc/default.conf

# Create container
sudo lxc-create -n arch -t download -- -d archlinux -r current -a arm64

# Start
sudo lxc-start -n arch
sudo lxc-info -n arch
LD_PRELOAD= sudo lxc-attach -n arch /bin/su -
```

Container config
```conf
# $PREFIX/var/lib/lxc/****/config

lxc.cgroup.devices.allow = a *:* rwm
lxc.mount.entry = /data/data/com.termux/files/usr/tmp tmp none bind,optional,create=dir
lxc.mount.entry = /data/data/com.termux/files/usr/tmp/.X11-unix tmp/.X11-unix none bind,ro,optional,create=dir
lxc.mount.entry = /dev/dri dev/dri none bind,optional,create=dir
lxc.mount.entry = /dev/dma_heap dev/dma_heap none bind,optional,create=dir
lxc.mount.entry = /dev/kgsl-3d0 dev/kgsl-3d0 none bind,optional,create=file
# For systemd-binfmt
lxc.mount.entry = /proc/sys/fs/binfmt_misc proc/sys/fs/binfmt_misc none bind,optional,create=dir
```

# Credits

* [lateautumn233](https://github.com/lateautumn233)
* [termux-packages](https://github.com/termux/termux-packages)
* [termux-packags-lxc](https://github.com/termux/termux-packages/tree/master/root-packages/lxc)
