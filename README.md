# quipper/actions-runner [![build](https://github.com/quipper/actions-runner/actions/workflows/build.yaml/badge.svg)](https://github.com/quipper/actions-runner/actions/workflows/build.yaml)

This is a container image of [actions/runner](https://github.com/actions/runner) for the new RunnerScaleSets.

## Purpose

We extend the Dockerfile of actions/runner to solve the following issues:

- We need to run a job on both amd64 and arm64 nodes.
  This repository provides a multi-architectures image.
  ([community#56720](https://github.com/orgs/community/discussions/56720))
- We would like to run both runner and Dockerd in same container for the resource efficiency of Kubernetes nodes.
  This image starts Dockerd under [tini](https://github.com/krallin/tini).
- We need to use [`ruby/setup-ruby`](https://github.com/ruby/setup-ruby#using-self-hosted-runners) but it does not support Debian.
  This image is based on Ubuntu. ([actions-runner-controller#2610](https://github.com/actions/actions-runner-controller/issues/2610))
- We need some essential packages such as `git`

We are looking for the official supports, but need to maintain our custom image for now.

For long-term maintainability and security,

- Align with the upstream image
- Keep less packages
- Keep simple logic

## Release

When a new version of actions/runner is released,

1. Renovate creates a pull request to update a dependency
2. We manually merge it
3. GitHub Actions automatically creates [a release](https://github.com/quipper/actions-runner/releases) corresponding to the runner version

Here is the versioning policy.

- Use same version as the upstream, such as `2.304.0`
- If we have added a change, increment the patch version. For example, if the upstream is `2.304.0`, we will create `2.304.1`

## Contributions

This is an open source project.
Feel free to open issues and pull requests for improving code and documents.
