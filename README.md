# Termux LXC LTS

LXC LTS Termux port


# Install

```bash
pkg upg
pkg i tsu
pkg i ./lxc-lts-****.deb
```


# Configure after installation

### Basic configure

Mount cgroup

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

Add mount point

```conf
lxc.cgroup.devices.allow = a *:* rwm

# Systemd-binfmt
lxc.mount.entry = /proc/sys/fs/binfmt_misc proc/sys/fs/binfmt_misc none bind,optional,create=dir

# Fuse
lxc.mount.entry = /dev/fuse dev/fuse none bind,optional,create=file
```

Mount binfmt

```bash
sudo mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
```

Configure Network (Host Mode)

```bash
sed -i 's/lxc\.net\.0\.type = empty/lxc.net.0.type = none/g' $PREFIX/etc/lxc/default.conf
```

### Display, Sound

Install packages

```bash
pkg upg
pkg i x11-repo -y
pkg i tsu pulseaudio termux-x11-nightly -y
```

Pulseaudio

```bash
pulseaudio --start \
    --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" \
    --exit-idle-time=-1
```

Add mount point

```conf
# X11
lxc.mount.entry = /data/data/com.termux/files/usr/tmp tmp none bind,optional,create=dir
lxc.mount.entry = /data/data/com.termux/files/usr/tmp/.X11-unix tmp/.X11-unix none bind,ro,optional,create=dir

# Freedreno Turnip (Only available for Qualcomm Snapdragon)
lxc.mount.entry = /dev/kgsl-3d0 dev/kgsl-3d0 none bind,optional,create=file
lxc.mount.entry = /dev/dri dev/dri none bind,optional,create=dir
lxc.mount.entry = /dev/dma_heap dev/dma_heap none bind,optional,create=dir
```


# Build Use Termux Packages

Clone repo

```bash
git clone https://github.com/TapetalArray/termux-lxc-lts
```

Add packages

```bash
cp -r termux-lxc-lts/packages/lxc-lts termux-packages/packages
```

Build

```bash
./build-package.sh -i -a aarch64 lxc-lts
```



# Credits

* [lxc](https://github.com/lxc/lxc)
* [termux-packages](https://github.com/termux/termux-packages)
* [lateautumn233](https://github.com/lateautumn233)
* [Running lxc for android](https://gist.github.com/lateautumn233/939be0528a2cc34af66864bead58e68a) (Chinese)
