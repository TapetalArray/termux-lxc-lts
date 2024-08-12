# Use Termux Packages

Clone this repo.
```bash
git clone https://github.com/TapetalArray/android-lxc-lts
```

Copy build configuration and patches.
```bash
cp ../android-lxc-lts/lxc-lts ./termux-packages/packages
```

Build.
```bash
./build-package.sh -i -a aarch64 lxc-lts
```

Build for Termux.
```bash
./build-package.sh -I lxc-lts
```