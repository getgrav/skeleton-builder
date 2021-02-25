#!/bin/sh -l

set -eu

# Prepping files will reside in /build
# Output zip packages will reside in /dist
mkdir /dist /build

# Variables prepping
REPOSITORY_NAME=$(echo "${GITHUB_REPOSITORY}" | awk -F / '{print $2}' | sed -e "s/:refs//")
VERSION=${SKELETON_VERSION:-$GITHUB_REF}
VERSION=$(echo "${VERSION}" | sed -e "s/refs\/heads\///" | sed -e "s/refs\/tags\///")
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

USER_EXCLUDE=$INPUT_EXCLUDE
FILENAME_VERSION="-${VERSION}"

if [ ! -z "$INPUT_EXCLUDE" ]; then
    USER_EXCLUDE=$(echo "-x '${INPUT_EXCLUDE}'")
fi

if ! $INPUT_FILENAME_VERSION; then
    FILENAME_VERSION=''
fi

# Create a package of the skeleton (w/o admin)
zip ${SILENT} -x "*.git/*" -x "*.github/workflows/*" -x *yarn.lock* -x *.gitignore* -x *.editorconfig* -x *.DS_Store* -x *hebe.json* -x *.dependencies* -x *.travis.yml* ${USER_EXCLUDE} -r "/dist/${REPOSITORY_NAME}${FILENAME_VERSION}.zip" .

# If option enabled, also create a package with admin included
if $INPUT_ADMIN; then
    bin/gpm install admin -y ${SILENT}
    zip ${SILENT} -x "*.git/*" -x "*.github/workflows/*" -x *yarn.lock* -x *.gitignore* -x *.editorconfig* -x *.DS_Store* -x *hebe.json* -x *.dependencies* -x *.travis.yml* ${USER_EXCLUDE} -r "/dist/${REPOSITORY_NAME}+admin${FILENAME_VERSION}.zip" .
fi

# Finally make the dist packages available in the workspace
mv /dist $GITHUB_WORKSPACE

# When in verbose mode, output a list of installed plugins/themes and final /build folder
if $INPUT_VERBOSE; then
    ls -la user/plugins
    ls -la user/themes
    ls -la $GITHUB_WORKSPACE/dist
fi
