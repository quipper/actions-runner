#!/bin/bash
set -eu -o pipefail
aws_region="$1"
echo "Modifying /etc/apt/sources.list for jammy x86_64 on AWS ${aws_region}" >&2
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
