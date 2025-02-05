# quipper/actions-runner [![build](https://github.com/quipper/actions-runner/actions/workflows/build.yaml/badge.svg)](https://github.com/quipper/actions-runner/actions/workflows/build.yaml)

This is a container image extending [actions/runner](https://github.com/actions/runner).

For maintainability and security,

- Align to the official image
- Keep the script simple
- Do not add extra packages

## Features

We extend the official image for the following issues:

- Run both runner and Dockerd in same container for the resource efficiency of Kubernetes nodes.
  This image starts Dockerd under docker-init.
- Add some essential packages such as `git`
- Support Ubuntu 20.04 runner for backward compatibility
- ~Run a job on both amd64 and arm64 nodes.
  This repository provides a multi-architectures image.
  ([community#56720](https://github.com/orgs/community/discussions/56720))~ (resolved by [actions/runner#2601](https://github.com/actions/runner/pull/2601))
- ~Support [`ruby/setup-ruby`](https://github.com/ruby/setup-ruby#using-self-hosted-runners) which does not support Debian.
  This image is based on Ubuntu. ([actions-runner-controller#2610](https://github.com/actions/actions-runner-controller/issues/2610))~ (resolved by [actions/runner#2651](https://github.com/actions/runner/pull/2651))
- ~Add a hosted tool cache for actions/setup-node ([#160](https://github.com/quipper/actions-runner/pull/160))~ (resolved by [actions/setup-node#857](https://github.com/actions/setup-node/issues/857))
- ~Automatically set the cloud-local APT sources to reduce time of apt-get ([#432](https://github.com/quipper/actions-runner/pull/432))~

We are looking for the official supports, but need to maintain our custom image for now.

## Release

When a new version of actions/runner is released,

1. Renovate creates a pull request to update a dependency
2. Renovate automatically merges it
3. GitHub Actions automatically creates [a release](https://github.com/quipper/actions-runner/releases) corresponding to the runner version

Here is the versioning policy.

- Use same version as the upstream, such as `2.304.0`
- If we have added a change, increment the patch version. For example, if the upstream is `2.304.0`, we will create `2.304.1`
