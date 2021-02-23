#!/bin/sh -l

set -eu

# Prepping files will reside in /build
# Output zip packages will reside in /dist
mkdir /dist /build

# Extrapolate version
printenv
VERSION=${GITHUB_EVENT_INPUTS_TAG:-GITHUB_REF}
echo "SKELETON_VERSION=${{ VERSION }}" >> $GITHUB_ENV
VERSION=$(echo "${VERSION}" | sed -e "s/refs\/heads\///" | sed -e "s/refs\/tags\///")

# Variables prepping
REPOSITORY_NAME=$(echo "${GITHUB_REPOSITORY}" | awk -F / '{print $2}' | sed -e "s/:refs//")
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
zip ${SILENT} -x "*.git/*" -x "*.github/workflows/*" -x *yarn.lock* -x *.gitignore* -x *.editorconfig* -x *.DS_Store* -x *hebe.json* -x *.dependencies* -x *.travis.yml* -r "/dist/${REPOSITORY_NAME}-${VERSION}.zip" .

# If option enabled, also create a package with admin included
if $INPUT_ADMINPLUGIN; then
    bin/gpm install admin -y ${SILENT}
    zip ${SILENT} -x "*.git/*" -x "*.github/workflows/*" -x *yarn.lock* -x *.gitignore* -x *.editorconfig* -x *.DS_Store* -x *hebe.json* -x *.dependencies* -x *.travis.yml* -r "/dist/${REPOSITORY_NAME}+admin-${VERSION}.zip" .
fi

# Finally make the dist packages available in the workspace
mv /dist $GITHUB_WORKSPACE

# When in verbose mode, output a list of installed plugins/themes and final /build folder
if $INPUT_VERBOSE; then
    ls -la user/plugins
    ls -la user/themes
    ls -la $GITHUB_WORKSPACE/dist
fi
