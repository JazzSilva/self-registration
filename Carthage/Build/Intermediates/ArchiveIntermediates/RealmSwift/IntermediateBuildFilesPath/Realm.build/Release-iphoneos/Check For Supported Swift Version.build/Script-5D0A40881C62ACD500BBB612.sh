#!/bin/sh
if [[ ! -e RealmSwift ]]; then
    version=$(readlink RealmSwift | sed 's/RealmSwift-swift//')
    echo >&2 "error: Swift $version is not supported."
    exit 1
fi

