#! /bin/bash

# Created by Posted byu/aravk33

set -e

BUILDDIR="${HOME}/build-rpi"
mkdir -p "${BUILDDIR}"
test -d "${BUILDDIR}/tools" || git -C "${BUILDDIR}" clone --depth=1 https://github.com/raspberrypi/tools.git
test -d "${BUILDDIR}/ripgrep" || git -C "${BUILDDIR}" clone --depth=1 --branch=0.8.1 https://github.com/BurntSushi/ripgrep.git

sudo apt update && sudo apt install -y gcc

PATH="${HOME}/.cargo/bin:${PATH}"
rustc --version || curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain="stable"

rustup target add arm-unknown-linux-gnueabihf

cat <<EOF > "${HOME}"/.cargo/config
[target.arm-unknown-linux-gnueabihf]
linker = "${HOME}/build-rpi/tools/arm-bcm2708/arm-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc"
EOF

pushd "${BUILDDIR}/ripgrep"
cargo build --release --target=arm-unknown-linux-gnueabihf
popd
