#!/usr/bin/env bash

# Locally overwrite pushd to not output to stout
pushd() {
    command pushd "$@" >/dev/null
}

# Locally overwrite popd to not output to stout
popd() {
    command popd "$@" >/dev/null
}

run() {
    # Set constants
    REPO_DIR="$(pwd)"
    SOURCE_DIR=$REPO_DIR/source
    NEW_VERSION=$1

    # Move into the source directory
    pushd $SOURCE_DIR

    # Build the deb
    dpkg -b com.favware.darkcons

    # Move the deb to the repo/debs folder
    mv com.favware.darkcons.deb ../debs/com.favware.darkcons_$NEW_VERSION.deb

    popd
    pushd $REPO_DIR

    # Create Packages index file
    dpkg-scanpackages -m ./debs >Packages

    # bzip the package index
    bzip2 -kfq Packages

    # Move out of the source directory
    popd
}

# Exit on errors
set -e

# Ensure a new version is given
if [[ "$1" == "" ]]; then
    echo "You need to provide a version to use for the new deb"
else
    run $1
fi
