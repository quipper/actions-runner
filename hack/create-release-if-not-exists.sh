#!/bin/bash
set -eux
actions_runner_version="$(grep RUNNER_VERSION= Dockerfile | cut -f2 -d=)"

if gh release view "$actions_runner_version"; then
  exit # already exists
fi

# create a release if not exists
gh release create "$actions_runner_version" --generate-notes
