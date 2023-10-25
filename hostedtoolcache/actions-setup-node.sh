#!/bin/bash
# This script downloads the specific version of Node.js into RUNNER_TOOL_CACHE directory.
# It is designed to work with https://github.com/actions/setup-node
set -eux -o pipefail

: "${TARGETARCH}"
: "${TARGETOS}"
: "${RUNNER_TOOL_CACHE}"

NODE_ARCH="${TARGETARCH}"
if [ "${TARGETARCH}" = "amd64" ]; then
  NODE_ARCH=x64
fi

NODE_VERSION="$(cat .node-version)"
test "${NODE_VERSION}"

function download_nodejs () {
  mkdir -p "${RUNNER_TOOL_CACHE}/node/${NODE_VERSION}/${NODE_ARCH}"

  curl -sf -o node.tar.gz -L "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-${TARGETOS}-${NODE_ARCH}.tar.gz"
  tar -xzf node.tar.gz -C "${RUNNER_TOOL_CACHE}/node/${NODE_VERSION}/${NODE_ARCH}"
  rm -v node.tar.gz
  touch "${RUNNER_TOOL_CACHE}/node/${NODE_VERSION}/${NODE_ARCH}.complete"

  chown -R runner:docker "${RUNNER_TOOL_CACHE}/node"
}

function verify_nodejs () {
  "${RUNNER_TOOL_CACHE}/node/${NODE_VERSION}/${NODE_ARCH}/node-v${NODE_VERSION}-${TARGETOS}-${NODE_ARCH}/bin/node" --version
}

download_nodejs
verify_nodejs
