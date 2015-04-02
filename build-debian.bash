#!/bin/bash -ex

. prepare.bash

### Build source package for each supported series.

cd ${GOPATH}

# Build for each supported Ubuntu version
for SERIES in $LTS_SERIES; do
	cat >debian/changelog <<EOF
hockeypuck (${PACKAGE_VERSION}~${SERIES}) ${SERIES}; urgency=medium

  * Release ${RELEASE_VERSION}.

 -- $DEBFULLNAME <$DEBEMAIL>  $(date -u -R)
EOF

	dpkg-buildpackage -rfakeroot -d -S -k0x879CF8AA8DDA301A
done

