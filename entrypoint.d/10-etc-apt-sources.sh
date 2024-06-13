#!/bin/bash
# This script modifies /etc/apt/sources.list to use the cloud-local APT sources.
set -eu -o pipefail

ubuntu_release="$(lsb_release -cs || true)"

aws_imds_token="$(curl -s --max-time 0.5 -X PUT http://169.254.169.254/latest/api/token -H 'X-aws-ec2-metadata-token-ttl-seconds: 30' || true)"

get_aws_region () {
  curl -sf -H "X-aws-ec2-metadata-token: $aws_imds_token" http://169.254.169.254/latest/meta-data/placement/region
}

get_aws_availability_zone () {
  curl -sf -H "X-aws-ec2-metadata-token: $aws_imds_token" http://169.254.169.254/latest/meta-data/placement/availability-zone
}

setup_aws_x86_64_jammy () {
  local region="$(get_aws_region)"
  echo "Modifying /etc/apt/sources.list for $(uname -m), ${ubuntu_release}, ${region}" >&2
  cat > /etc/apt/sources.list <<EOF
deb http://${region}.ec2.archive.ubuntu.com/ubuntu/ jammy main restricted
deb http://${region}.ec2.archive.ubuntu.com/ubuntu/ jammy-updates main restricted
deb http://${region}.ec2.archive.ubuntu.com/ubuntu/ jammy universe
deb http://${region}.ec2.archive.ubuntu.com/ubuntu/ jammy-updates universe
deb http://${region}.ec2.archive.ubuntu.com/ubuntu/ jammy multiverse
deb http://${region}.ec2.archive.ubuntu.com/ubuntu/ jammy-updates multiverse
deb http://${region}.ec2.archive.ubuntu.com/ubuntu/ jammy-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu jammy-security main restricted
deb http://security.ubuntu.com/ubuntu jammy-security universe
deb http://security.ubuntu.com/ubuntu jammy-security multiverse
EOF
}

setup_aws_aarch64_jammy () {
  local availability_zone="$(get_aws_availability_zone)"
  echo "Modifying /etc/apt/sources.list for $(uname -m), ${ubuntu_release}, ${availability_zone}" >&2
  cat > /etc/apt/sources.list <<EOF
deb http://${availability_zone}.clouds.ports.ubuntu.com/ubuntu-ports/ jammy main restricted
deb http://${availability_zone}.clouds.ports.ubuntu.com/ubuntu-ports/ jammy-updates main restricted
deb http://${availability_zone}.clouds.ports.ubuntu.com/ubuntu-ports/ jammy universe
deb http://${availability_zone}.clouds.ports.ubuntu.com/ubuntu-ports/ jammy-updates universe
deb http://${availability_zone}.clouds.ports.ubuntu.com/ubuntu-ports/ jammy multiverse
deb http://${availability_zone}.clouds.ports.ubuntu.com/ubuntu-ports/ jammy-updates multiverse
deb http://${availability_zone}.clouds.ports.ubuntu.com/ubuntu-ports/ jammy-backports main restricted universe multiverse
deb http://ports.ubuntu.com/ubuntu-ports jammy-security main restricted
deb http://ports.ubuntu.com/ubuntu-ports jammy-security universe
deb http://ports.ubuntu.com/ubuntu-ports jammy-security multiverse
EOF
}

if [ "$aws_imds_token" ]; then
  case "$(uname -m)_${ubuntu_release}" in
    x86_64_jammy)  setup_aws_x86_64_jammy;;
    aarch64_jammy) setup_aws_aarch64_jammy;;
  esac
  exit
fi
