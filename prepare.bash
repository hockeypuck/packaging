#!/bin/bash -ex

export DEBEMAIL="cmars@cmarstech.com"
export DEBFULLNAME="Casey Marshall"

export RELEASE_VERSION=2.0~rc2

export BUILD_PACKAGE=github.com/hockeypuck/server

### Set up GOPATH

export GOPATH=$(pwd)
for pkg in github.com/rogpeppe/godeps github.com/mitchellh/gox; do
	go get ${pkg}
	go install ${pkg}
done

go get -d -t ${BUILD_PACKAGE}/...

cd src/${BUILD_PACKAGE}
${GOPATH}/bin/godeps -u dependencies.tsv

export SHORTHASH=$(git log -1 --pretty=format:%h)
export LONGHASH=$(git log -1 --pretty=format:%H)
export HEXDATE=$(date +%s)

### Set up webroot

cd ${GOPATH}
mkdir -p instroot/var/lib/hockeypuck
cd instroot/var/lib/hockeypuck
if [ ! -d www ]; then
	git clone https://github.com/hockeypuck/webroot.git www
fi
# TODO: set webroot revision?

# Get our current and last built revision
export LTS_SERIES="precise trusty"
export PACKAGE_VERSION="${RELEASE_VERSION}~${HEXDATE}+${SHORTHASH}"

cd ${GOPATH}
echo "$LONGHASH" > version-git-commit
echo "$PACKAGE_VERSION" > version-release

