#!/bin/sh

# Old versions resided in /System/Library, remove.
rm -rf /Library/Extensions/tun.kext
rm -rf /Library/Extensions/tap.kext

# Unload an old extension (might fail).
kextunload -b net.tunnelblick.tun


rm -rf /Library/LaunchDaemons/happynet.plist
rm -rf /Library/LaunchDaemons/net.tunnelblick.tap.plist
rm -rf /Library/LaunchDaemons/net.tunnelblick.tun.plist
rm -rf /Applications/happynet

