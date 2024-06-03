# Termux LXC

LXC LTS ported for Termux

# Build

Clone this repo
```bash
git clone https://github.com/TapetalArray/termux-lxc-lts
```

Setup Termux Packages
```bash
git clone https://github.com/termux/termux-packages
cd ./termux-packages
```

Setup Archlinux
```bash
./scripts/setup-archlinux.sh
```

Setup Ubuntu
```bash
./scripts/setup-ubuntu.sh
```

Setup Android SDK
```bash
./scripts/setup-android-sdk.sh
```

Setup Termux
```bash
./scripts/setup-termux.sh
```

Copy build configuration and patches
```bash
cp ../termux-lxc-lts/lxc-lts ./termux-packages/packages
```

Build
```bash
./build-package.sh -i -a aarch64 lxc-lts
```

Build for Termux
```bash
./build-package.sh -I lxc-lts
```

# Install
Install dependencies
```bash
pkg upg
pkg i x11-repo -y
pkg i tsu pulseaudio termux-x11-nightly -y
pkg i ./lxc-lts-****.deb
```

# Usage
You can refer to [this](https://gist.github.com/lateautumn233/939be0528a2cc34af66864bead58e68a) (Chinese)

Start Pulseaudio
```bash
pulseaudio --start \
    --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" \
    --exit-idle-time=-1
```

Start Termux X11
```bash
termux-x11 &
```

Mount cgroup (Optional)
```bash
for cg in blkio cpu cpuacct cpuset devices freezer memory; do
   if [ ! -d "/sys/fs/cgroup/${cg}" ]; then
       sudo mkdir -p "/sys/fs/cgroup/${cg}"
   fi

   if ! sudo mountpoint -q "/sys/fs/cgroup/${cg}"; then
       sudo mount -t cgroup -o "${cg}" cgroup "/sys/fs/cgroup/${cg}" || true
   fi
done
```

Systemd-binfmt
```bash
sudo mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
```

Configure Network
```bash
sed -i 's/lxc\.net\.0\.type = empty/lxc.net.0.type = none/g' $PREFIX/etc/lxc/default.conf
```

Create container
```bash
sudo lxc-create -n arch -t download -- -d archlinux -r current -a arm64
```

Start
```bash
sudo lxc-start -n arch
sudo lxc-info -n arch
LD_PRELOAD= sudo lxc-attach -n arch /bin/su -
```

# Config
Write to $PREFIX/var/lib/lxc/****/config
```conf
lxc.cgroup.devices.allow = a *:* rwm
lxc.mount.entry = /data/data/com.termux/files/usr/tmp tmp none bind,optional,create=dir
lxc.mount.entry = /data/data/com.termux/files/usr/tmp/.X11-unix tmp/.X11-unix none bind,ro,optional,create=dir
lxc.mount.entry = /dev/dri dev/dri none bind,optional,create=dir
lxc.mount.entry = /dev/dma_heap dev/dma_heap none bind,optional,create=dir
lxc.mount.entry = /dev/kgsl-3d0 dev/kgsl-3d0 none bind,optional,create=file

# For systemd-binfmt
lxc.mount.entry = /proc/sys/fs/binfmt_misc proc/sys/fs/binfmt_misc none bind,optional,create=dir

# For fuse
lxc.mount.entry = /dev/fuse dev/fuse none bind,optional,create=file
```

# Credits

* [lateautumn233](https://github.com/lateautumn233)
* [termux-packages](https://github.com/termux/termux-packages)
* [termux-packags-lxc](https://github.com/termux/termux-packages/tree/master/root-packages/lxc)
