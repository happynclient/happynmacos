#!/bin/sh

# Old versions resided in /System/Library, remove.
rm -rf /Library/Extensions/tun.kext
rm -rf /Library/Extensions/tap.kext

# Unload an old extension (might fail).
kextunload -b net.tunnelblick.tun 2>/dev/null
kextunload -b net.tunnelblick.tap 2>/dev/null

launchctl unload -w /Library/LaunchDaemons/net.happyn.plist 2>/dev/null


rm -rf /Library/LaunchDaemons/net.happyn.plist
rm -rf /Library/LaunchDaemons/net.tunnelblick.tap.plist
rm -rf /Library/LaunchDaemons/net.tunnelblick.tun.plist
rm -rf /Applications/happynet

echo "happyn uninstall successful"
