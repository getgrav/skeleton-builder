#!/bin/sh -l

set -eu

# Prepping files will reside in /dist
# Output zip builds will reside in /build
mkdir /dist /build

# Variables prepping
REPOSITORY_NAME=$(echo "${GITHUB_REPOSITORY}" | awk -F / '{print $2}' | sed -e "s/:refs//")
VERSION=$($GITHUB_REF | sed -e "s/refs\/heads\///")
SILENT='-q'
CURL_SILENT='--silent'

if $INPUT_VERBOSE; then
    SILENT=
    CURL_SILENT=
fi

# Download Grav @ specific version and get it ready for the Skeleton
cd /build
curl --write-out '%{http_code}' ${CURL_SILENT} --location https://getgrav.org/download/core/grav/${INPUT_VERSION} > grav.zip;
unzip ${SILENT} grav.zip
rm -rf grav.zip

cd grav

# Install the skeleton user folder
rm -rf user
cp -Rf $GITHUB_WORKSPACE user
bin/grav install ${SILENT}

# Create a package of the skeleton (w/o admin)
zip ${SILENT} -x "*.git/*" -x "*.github/workflows/*" -x *yarn.lock* -x *.gitignore* -x *.editorconfig* -x *.DS_Store* -x *hebe.json* -x *.dependencies* -x *.travis.yml* -r "/dist/${REPOSITORY_NAME}-${VERSION}.zip" /build

# If option enabled, also create a package with admin included
if $INPUT_ADMINPLUGIN; then
    bin/gpm install admin -y ${SILENT}
    zip ${SILENT} -x "*.git/*" -x "*.github/workflows/*" -x *yarn.lock* -x *.gitignore* -x *.editorconfig* -x *.DS_Store* -x *hebe.json* -x *.dependencies* -x *.travis.yml* -r "/dist/${REPOSITORY_NAME}+admin-${VERSION}.zip" /build
fi

# When in verbose mode, output a list of installed plugins/themes and final /build folder
if $INPUT_VERBOSE; then
    ls -la user/plugins
    ls -la user/themes
    ls -la /build
fi
