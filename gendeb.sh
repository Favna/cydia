#!/usr/bin/env bash

run() {
    # Store new version in variable
    NEW_VERSION=$1

    # Create directory for rootless
    mkdir -p source/tech.favware.darkcons-rootless/var/jb/

    # Copy theme files
    cp -r themes/* source/tech.favware.darkcons/
    cp -r themes/* source/tech.favware.darkcons-rootless/var/jb/

    # Move into the source directory
    cd source

    # Build the debs
    dpkg -b tech.favware.darkcons
    dpkg -b tech.favware.darkcons-rootless

    # Move the debs to the repo/debs folder
    mv tech.favware.darkcons.deb ../debs/tech.favware.darkcons_${NEW_VERSION}.deb
    mv tech.favware.darkcons-rootless.deb ../debs/tech.favware.darkcons-rootless_${NEW_VERSION}.deb

    # Move back to root
    cd ../

    # Create Packages index file
    dpkg-scanpackages -m ./debs > Packages

    # bzip the package index
    bzip2 -kfq Packages
}

# Exit on errors
set -e

# Ensure a new version is given
if [[ "$1" == "" ]]; then
    echo "You need to provide a version to use for the new deb"
else
    run $1
fi
