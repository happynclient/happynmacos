# Lets have a version, at last!
HAPPYNET_VERSION = 2.0

# BASE install directory
BASE=

all: pkg

keysetup:
	-security delete-keychain net.tunnelblick.tmp
	security create-keychain -p $$(head -c 32 /dev/urandom | hexdump -e '"%02x"') \
		net.tunnelblick.tmp
	security set-keychain-settings -lut 60 net.tunnelblick.tmp
	security import identity.p12 -k net.tunnelblick.tmp -f pkcs12 \
		-P $$(read -sp 'identity passphrase: ' pw && echo "$$pw") -A
	security find-identity -v net.tunnelblick.tmp | \
		awk -F \" '$$2 ~ /^Developer ID Application:/ { print $$2 }' > .signing_identity
	security find-identity -v net.tunnelblick.tmp | \
		awk -F \" '$$2 ~ /^Developer ID Installer:/ { print $$2 }' > .installer_identity

pkgbuild/%.pkg:
	mkdir -p pkgbuild/$*_root/Library/Extensions
	cp -pR pkg/driver/$*.kext pkgbuild/$*_root/Library/Extensions
	mkdir -p pkgbuild/$*_root/Library/LaunchDaemons
	cp pkg/launchd/net.tunnelblick.$*.plist pkgbuild/$*_root/Library/LaunchDaemons
	pkgbuild --root pkgbuild/$*_root \
		--component-plist pkg/components/$*.plist \
		--scripts pkg/scripts/$* pkgbuild/$*.pkg

happynet_$(HAPPYNET_VERSION).pkg: pkgbuild/tap.pkg pkgbuild/tun.pkg
	productbuild --distribution pkg/distribution.xml --package-path pkgbuild \
		--resources pkg/res.dummy \
		happynet_$(HAPPYNET_VERSION).pkg ; \
	pkgutil --expand happynet_$(HAPPYNET_VERSION).pkg pkgbuild/happynet_pkg.d
	cp -pR pkg/res/ pkgbuild/happynet_pkg.d/Resources
	pkgutil --flatten pkgbuild/happynet_pkg.d happynet_$(HAPPYNET_VERSION).pkg
	if test -s ".installer_identity"; then \
		productsign --sign "$$(cat .installer_identity)" --keychain net.tunnelblick.tmp \
			happynet_$(HAPPYNET_VERSION).pkg happynet_$(HAPPYNET_VERSION).pkg.signed ; \
		mv happynet_$(HAPPYNET_VERSION).pkg.signed happynet_$(HAPPYNET_VERSION).pkg ; \
	fi

pkg: happynet_$(HAPPYNET_VERSION).pkg
	tar czf happynet_$(HAPPYNET_VERSION).tar.gz \
		README.md happynet_$(HAPPYNET_VERSION).pkg 



tarball: clean
	touch happynet_$(HAPPYNET_VERSION)_src.tar.gz
	tar czf happynet_$(HAPPYNET_VERSION)_src.tar.gz \
		-C .. \
		--exclude "tuntap/identity.p12" \
		--exclude "tuntap/happynet_$(HAPPYNET_VERSION)_src.tar.gz" \
		--exclude "tuntap/happynet_$(HAPPYNET_VERSION).tar.gz" \
		--exclude "tuntap/happynet_$(HAPPYNET_VERSION).pkg" \
		--exclude "*/.*" \
		tuntap

clean:
	-rm -rf pkgbuild
	-rm -rf happynet_$(HAPPYNET_VERSION).pkg
	-rm -f happynet_$(HAPPYNET_VERSION).tar.gz
	-rm -f happynet_$(HAPPYNET_VERSION)_src.tar.gz


test:
	# configd messes with interface flags, issuing SIOCSIFFLAGS ioctls upon receiving kernel
	# events indicating protocols have been attached and detached. Unfortunately, configd does
	# this asynchronously, making the SIOCSIFFLAGS changes totally unpredictable when we bring
	# our interfaces up and down in rapid succession during our tests. I haven't found a good
	# way to suppress or handle this mess other than disabling configd temporarily.
	killall -STOP configd
	-PYTHONPATH=test python test/tuntap/happynet_tests.py --tests='$(TESTS)'
	killall -CONT configd

.PHONY: test
