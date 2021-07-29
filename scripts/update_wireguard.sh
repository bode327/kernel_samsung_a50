#!/bin/bash

#git clone git://git.zx2c4.com/wireguard-linux-compat
#rm -fr net/wireguard/*

#perl -i -ne 'BEGIN{$print=1;} $print = 0 if m/cat/; print $_ if $print;' wireguard-linux-compat/kernel-tree-scripts/create-patch.sh

#wireguard-linux-compat/kernel-tree-scripts/create-patch.sh | patch -p1

#rm -fr wireguard-linux-compat

#git checkout net/wireguard/crypto/zinc/chacha20/.gitignore \
#	     net/wireguard/crypto/zinc/poly1305/.gitignore \
#	     net/wireguard/Kconfig

set -e
USER_AGENT="WireGuard-AndroidROMBuild/0.3 ($(uname -a))"

exec 9>.wireguard-fetch-lock
flock -n 9 || exit 0

[[ $(( $(date +%s) - $(stat -c %Y "net/wireguard/.check" 2>/dev/null || echo 0) )) -gt 86400 ]] || exit 0

while read -r distro package version _; do
	if [[ $distro == upstream && $package == linuxcompat ]]; then
		VERSION="$version"
		break
	fi
done < <(curl -A "$USER_AGENT" -LSs --connect-timeout 30 https://build.wireguard.com/distros.txt)

[[ -n $VERSION ]]

if [[ -f net/wireguard/version.h && $(< net/wireguard/version.h) == *$VERSION* ]]; then
	touch net/wireguard/.check
	exit 0
fi

rm -rf net/wireguard
mkdir -p net/wireguard
curl -A "$USER_AGENT" -LsS --connect-timeout 30 "https://git.zx2c4.com/wireguard-linux-compat/snapshot/wireguard-linux-compat-$VERSION.tar.xz" | tar -C "net/wireguard" -xJf - --strip-components=2 "wireguard-linux-compat-$VERSION/src"
sed -i 's/tristate/bool/;s/default m/default y/;' net/wireguard/Kconfig
touch net/wireguard/.check	     
