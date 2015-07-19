#!/bin/bash -xe

. prepare.bash

for cmdpkg in $(go list ${BUILD_PACKAGE}/cmd/...); do
	$GOPATH/bin/gox -os '!windows !netbsd !plan9' \
		-output 'build/{{.OS}}_{{.Arch}}/usr/bin/{{.Dir}}' \
		-ldflags "-X github.com/hockeypuck/server.version ${PACKAGE_VERSION}" \
		$cmdpkg
done

mkdir -p dist

for osarch in $(ls build); do
	tarfile=dist/hockeypuck-${PACKAGE_VERSION}-${osarch}.tar
	tar -C build/${osarch} -cf ${tarfile} .
	tar -C instroot -rf ${tarfile} .
	gzip -9 ${tarfile}
done
