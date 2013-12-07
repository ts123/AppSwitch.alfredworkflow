#!/bin/bash
echo $0 "$@"
# find . -name .git -prune -o -type f

TAG_NAME=${TRAVIS_BRANCH}
echo TAG_NAME:$TAG_NAME
if [[ ! "$TAG_NAME" =~ [0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo $TAG_NAME is not a valid tag name
    exit
fi

# asset file to be uploaded to github release
ASEET_DIR=bin
ASSET_FILE=AppSwitch.alfredworkflow

# setup json parser
_downloadjq() {
    if [ $(uname) = "Darwin" ] ; then
        if uname -m | grep '64' > /dev/null; then
            platform=osx64
        else
            platform=osx32
        fi
    else
        if uname -m | grep '64' > /dev/null; then
            platform=linux64
        else
            platform=linux32
        fi
    fi
    wget http://stedolan.github.io/jq/download/${platform}/jq
}
JQ() {
    if command -v jq >/dev/null; then
        cmd=jq
    else
        if [[ ! -f ./jq ]]; then
            _downloadjq
            chmod +x ./jq
        fi
        cmd=./jq
    fi
    $cmd "$@"
}

getreleaseid() {
    curl -s "https://api.github.com/repos/${1}/releases" | JQ '. | map(select(.tag_name == "'${2}'")) | .[0].id'
}

# if github relese id already exists, create again
RELEASE_ID=$(getreleaseid ${TRAVIS_REPO_SLUG} ${TAG_NAME})
if [ ! "$RELEASE_ID" == "null" ]; then
    echo remove release:$RELEASE_ID
    # remove github release
    curl -H "Authorization: token ${TOKEN}" \
         -X DELETE \
         "https://api.github.com/repos/${TRAVIS_REPO_SLUG}/releases/${RELEASE_ID}"
fi

# create github release
echo create release
rm -f data.json
printf '{"tag_name":"%s", "target_commitish":"%s", "draft":"true"}' "${TAG_NAME}" "${TRAVIS_COMMIT}" > data.json
curl -H "Authorization: token ${TOKEN}" \
     -H "Accept: application/vnd.github.manifold-preview" \
     -X POST \
     -d @data.json \
     "https://api.github.com/repos/${TRAVIS_REPO_SLUG}/releases"

RELEASE_ID=$(getreleaseid ${TRAVIS_REPO_SLUG} ${TAG_NAME})
if [ "$RELEASE_ID" == "null" ]; then
    echo releaseid:$RELEASE_ID not found
    exit 1
fi

# upload package.zip
echo upload ${ASSET_FILE}
curl -H "Authorization: token ${TOKEN}" \
     -H "Accept: application/vnd.github.manifold-preview" \
     -H "Content-Type: application/zip" \
     --data-binary @${ASEET_DIR}/${ASSET_FILE} \
     "https://uploads.github.com/repos/${TRAVIS_REPO_SLUG}/releases/${RELEASE_ID}/assets?name=${ASSET_FILE}"

