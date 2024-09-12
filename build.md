# Use Termux Packages

Clone this repo

```bash
git clone https://github.com/TapetalArray/termux-lxc-lts
```

Copy build configuration and patches

```bash
cp -r termux-lxc-lts/packages/lxc-lts termux-packages/packages
```

Build

```bash
./build-package.sh -i -a aarch64 lxc-lts
```
