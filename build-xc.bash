#!/bin/bash -xe

. prepare.bash

cd ${GOPATH}/src/${BUILD_PACKAGE}

goxc -pv=${PACKAGE_VERSION} -bc="linux,darwin,freebsd,openbsd" -d=${GOPATH}/dist
