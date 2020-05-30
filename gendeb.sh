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
    NEW_VERSION=$2

    # Move into the source directory
    pushd $SOURCE_DIR

    # Determine for which package a deb should be created
    if [[ "$1" == "extra" ]]; then

        # Build the deb
        dpkg -b com.favware.lotusdarkextra

        # Move the deb to the repo/debs folder
        mv com.favware.lotusdarkextra.deb ../debs/com.favware.lotusdarkextra_$NEW_VERSION.deb

    # Determine for which package a deb should be created
    elif [[ "$1" == "extra13" ]]; then

        # Build the deb
        dpkg -b com.favware.lotusdarkextra13

        # Move the deb to the repo/debs folder
        mv com.favware.lotusdarkextra13.deb ../debs/com.favware.lotusdarkextra13_$NEW_VERSION.deb

    elif [[ "$1" == "vpn" ]]; then

        # Build the deb
        dpkg -b com.favware.lotusdarksettingsvpnicon

        # Move the deb to the repo/debs folder
        mv com.favware.lotusdarksettingsvpnicon.deb ../debs/com.favware.lotusdarksettingsvpnicon_$NEW_VERSION.deb

    else

        # Fallback case
        echo "Unsupported package provided"
        return 0

    fi
    popd
    pushd $REPO_DIR

    # Create Packages index file
    dpkg-scanpackages -m ./debs >Packages

    # Replace all old email entries with new email entries in the package index
    yarn replace-in-file '/support\@favna\.xyz/gm' 'support@favware.tech' ./Packages --isRegex

    # Replace all old categories with the new category
    yarn replace-in-file '/Themes \(Addons\)/gm' 'Themes' ./Packages --isRegex

    # bzip the package index
    bzip2 -kfq Packages

    # Move out of the source directory
    popd
}

# Exit on errors
set -e

# Ensure a new version is given
if [[ "$2" == "" ]]; then
    echo "You need to provide a version to use for the new deb"
else
    # Generate the proper deb
    case $1 in
    vpn)
        run vpn $2
        ;;
    extra)
        run extra $2
        ;;
    extra13)
        run extra13 $2
        ;;
    *)
        echo "Unsupported package provided"
        exit 0
        ;;
    esac
fi
