#!/bin/sh -l

set -eu

$REPOSITORY_NAME=$(echo "$GITHUB_REPOSITORY" | awk -F / '{print $2}' | sed -e "s/:refs//")
$VERSION=$GITHUB_REF


echo "${REPOSITORY_NAME} ${VERSION}"
echo $INPUT_VERSION
echo $INPUT_ADMINPLUGIN


curl -L https://getgrav.org/download/core/grav/${INPUT_VERSION} > /grav.zip;

ls .
ls -la /
# zip -q -x "*.git/*" -x "*.github/workflows/*" -x *yarn.lock* -x *.gitignore* -x *.editorconfig* -x *.DS_Store* -x *hebe.json* -x *.dependencies* -x *.travis.yml* -r $1 $2