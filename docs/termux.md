# Install

Install dependencies.

```bash
pkg upg
pkg i tsu
pkg i ./lxc-lts-****.deb
```

# Build
[Check This](https://github.com/TapetalArray/android-lxc-lts/tree/main/termux-build/README.md)


# Recommended after installation

Mount Cgroup (Optional).
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

For $PREFIX/var/lib/lxc/name/config.
```conf
lxc.cgroup.devices.allow = a *:* rwm

# For systemd-binfmt.
lxc.mount.entry = /proc/sys/fs/binfmt_misc proc/sys/fs/binfmt_misc none bind,optional,create=dir

# For fuse
lxc.mount.entry = /dev/fuse dev/fuse none bind,optional,create=file
```

For Systemd-binfmt
```bash
sudo mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
```

Configure Network (Use host mode)
```bash
sed -i 's/lxc\.net\.0\.type = empty/lxc.net.0.type = none/g' $PREFIX/etc/lxc/default.conf
```

If you don't use x11 and pulse, you can skip this.

Recommended package
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

For $PREFIX/var/lib/lxc/name/config
```conf
# For Termux X11
lxc.mount.entry = /data/data/com.termux/files/usr/tmp tmp none bind,optional,create=dir
lxc.mount.entry = /data/data/com.termux/files/usr/tmp/.X11-unix tmp/.X11-unix none bind,ro,optional,create=dir

# For Freedreno Turnip (Only available for Qualcomm Snapdragon)
lxc.mount.entry = /dev/kgsl-3d0 dev/kgsl-3d0 none bind,optional,create=file
lxc.mount.entry = /dev/dri dev/dri none bind,optional,create=dir
lxc.mount.entry = /dev/dma_heap dev/dma_heap none bind,optional,create=dir
```