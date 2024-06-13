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

modify_for_aws_x86_64_jammy () {
  local aws_region="$(get_aws_region)"
  echo "Modifying /etc/apt/sources.list for ${aws_region}" >&2
  cat > /etc/apt/sources.list <<EOF
deb http://${aws_region}.ec2.archive.ubuntu.com/ubuntu/ jammy main restricted
deb http://${aws_region}.ec2.archive.ubuntu.com/ubuntu/ jammy-updates main restricted
deb http://${aws_region}.ec2.archive.ubuntu.com/ubuntu/ jammy universe
deb http://${aws_region}.ec2.archive.ubuntu.com/ubuntu/ jammy-updates universe
deb http://${aws_region}.ec2.archive.ubuntu.com/ubuntu/ jammy multiverse
deb http://${aws_region}.ec2.archive.ubuntu.com/ubuntu/ jammy-updates multiverse
deb http://${aws_region}.ec2.archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu jammy-security main restricted
deb http://security.ubuntu.com/ubuntu jammy-security universe
deb http://security.ubuntu.com/ubuntu jammy-security multiverse
EOF
}

modify_for_aws_aarch64_jammy () {
  local aws_availability_zone="$(get_aws_availability_zone)"
  echo "Modifying /etc/apt/sources.list for ${aws_availability_zone}" >&2
  cat > /etc/apt/sources.list <<EOF
deb http://${aws_availability_zone}.clouds.ports.ubuntu.com/ubuntu-ports/ jammy main restricted
deb http://${aws_availability_zone}.clouds.ports.ubuntu.com/ubuntu-ports/ jammy-updates main restricted
deb http://${aws_availability_zone}.clouds.ports.ubuntu.com/ubuntu-ports/ jammy universe
deb http://${aws_availability_zone}.clouds.ports.ubuntu.com/ubuntu-ports/ jammy-updates universe
deb http://${aws_availability_zone}.clouds.ports.ubuntu.com/ubuntu-ports/ jammy multiverse
deb http://${aws_availability_zone}.clouds.ports.ubuntu.com/ubuntu-ports/ jammy-updates multiverse
deb http://${aws_availability_zone}.clouds.ports.ubuntu.com/ubuntu-ports/ jammy-backports main restricted universe multiverse
deb http://ports.ubuntu.com/ubuntu-ports jammy-security main restricted
deb http://ports.ubuntu.com/ubuntu-ports jammy-security universe
deb http://ports.ubuntu.com/ubuntu-ports jammy-security multiverse
EOF
}

modify_for_aws () {
  local platform="$(uname -m)"
  local ubuntu_release="$(lsb_release -cs || true)"
  echo "Running on EC2 ${platform} ${ubuntu_release}" >&2
  if [[ $platform == x86_64 && $ubuntu_release == jammy ]]; then
    modify_for_aws_x86_64_jammy
  elif [[ $platform == aarch64 && $ubuntu_release == jammy ]]; then
    modify_for_aws_aarch64_jammy
  fi
}

if [ -n "${aws_imds_token}" ]; then
  modify_for_aws
fi
