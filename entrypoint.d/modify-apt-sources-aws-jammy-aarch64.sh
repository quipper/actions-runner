#!/bin/bash
set -eu -o pipefail
aws_availability_zone="$1"
echo "Modifying /etc/apt/sources.list for jammy aarch64 on AWS ${aws_availability_zone}" >&2
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
