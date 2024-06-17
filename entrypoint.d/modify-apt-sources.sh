#!/bin/bash
# This script modifies /etc/apt/sources.list to use the cloud-local APT sources.
set -eu -o pipefail

# Set a timeout to avoid hanging if the IMDSv2 endpoint is not available.
aws_imds_token="$(curl -sf --max-time 0.5 -X PUT http://169.254.169.254/latest/api/token -H 'X-aws-ec2-metadata-token-ttl-seconds: 30' || true)"

get_aws_region () {
  curl -sf -H "X-aws-ec2-metadata-token: $aws_imds_token" http://169.254.169.254/latest/meta-data/placement/region
}

get_aws_availability_zone () {
  curl -sf -H "X-aws-ec2-metadata-token: $aws_imds_token" http://169.254.169.254/latest/meta-data/placement/availability-zone
}

local ubuntu_release="$(lsb_release -cs || true)"
local platform="$(uname -m)"
echo "Running on Ubuntu ${ubuntu_release} ${platform}" >&2

if [[ -z "${aws_imds_token}" ]]; then
  exit
fi

if [[ $ubuntu_release == jammy && $platform == x86_64 ]]; then
  bash /entrypoint.d/modify-apt-sources-jammy-x86_64.sh "$(get_aws_region)"
elif [[ $ubuntu_release == jammy && $platform == aarch64 ]]; then
  bash /entrypoint.d/modify-apt-sources-jammy-aarch64.sh "$(get_aws_availability_zone)"
fi
