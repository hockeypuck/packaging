#!/bin/bash -ex

export DEBEMAIL="cmars@cmarstech.com"
export DEBFULLNAME="Casey Marshall"

RELEASE_VERSION=2.0~a1

BUILD_PACKAGE=github.com/hockeypuck/server

### Set up GOPATH

export GOPATH=$(pwd)
go get launchpad.net/godeps
go install launchpad.net/godeps

go get -d -t ${BUILD_PACKAGE}/...

cd src/${BUILD_PACKAGE}
${GOPATH}/bin/godeps -u dependencies.tsv

SHORTHASH=$(git log -1 --pretty=format:%h)
LONGHASH=$(git log -1 --pretty=format:%H)
HEXDATE=$(python2 -c "print '%x' % $(date +%s)")

### Set up webroot

cd ${GOPATH}
mkdir -p instroot/var/lib/hockeypuck
cd instroot/var/lib/hockeypuck
git clone https://github.com/hockeypuck/webroot.git www
# TODO: set webroot revision?

# Get our current and last built revision
DISTS="precise trusty"
PACKAGE_VERSION="${RELEASE_VERSION}+${HEXDATE}+${SHORTHASH}"

echo "$LONGHASH" > version-git-commit
echo "$PACKAGE_VERSION" > version-release

# Build for each supported Ubuntu version
for DIST in $DISTS; do
	cat >debian/changelog <<EOF
hockeypuck (${PACKAGE_VERSION}~${DIST}) ${DIST}; urgency=medium

  * Release ${RELEASE_VERSION}.

 -- $DEBFULLNAME <$DEBEMAIL>  $(date -u -R)
EOF

	dpkg-buildpackage -rfakeroot -d -S -us -uc
done

