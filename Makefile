# Lets have a version, at last!
HAPPYNET_VERSION = 1.2

# BASE install directory
BASE=

all: pkg

pkg: happynet$(HAPPYNET_VERSION).pkg happynetArm$(HAPPYNET_VERSION).pkg

happynet$(HAPPYNET_VERSION).pkg:
	/usr/local/bin/packagesbuild --package-version $(HAPPYNET_VERSION) happynmacos.pkgproj
	mv build/happynmacos.pkg build/happynet$(HAPPYNET_VERSION).pkg

happynetArm$(HAPPYNET_VERSION).pkg:
	/usr/local/bin/packagesbuild --package-version $(HAPPYNET_VERSION) happynmacosArm.pkgproj
	mv build/happynmacosArm.pkg build/happynetArm$(HAPPYNET_VERSION).pkg

clean:
	-rm -rf build/happynet*.pkg

