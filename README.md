# quipper/actions-runner [![build](https://github.com/quipper/actions-runner/actions/workflows/build.yaml/badge.svg)](https://github.com/quipper/actions-runner/actions/workflows/build.yaml)

This is a container image of [actions/runner](https://github.com/actions/runner) for RunnerScaleSets.

## Purpose

We extend the official image of actions/runner to solve the following issues:

- It does not provide a multi-architectures image.
  We need to run a job on both amd64 and arm64 nodes ([#56720](https://github.com/orgs/community/discussions/56720))
- It does not provide an image including dockerd.
  We would like to run both in same container for the resource efficiency in Kubernetes node
- It is based on Debian, but some actions depend on Ubuntu, such as [`ruby/setup-ruby`](https://github.com/ruby/setup-ruby#using-self-hosted-runners)

As well as we add some packages for our workflows.
We'd like to keep the image small as possible.
DO NOT add any package unless we really need it.

For long-term maintainability and security,

- Align with the upstream image
- Less image size as possible
- Less logic as possible

## Release

When a new version of actions/runner is released,

1. Renovate creates a pull request
2. We merge it
3. We [create a new release](https://github.com/quipper/actions-runner/releases)

Here is the versioning policy.

- Use same version as the upstream, such as `2.304.0`
- If we have added a change, increment the patch version. For example, if the upstream is `2.304.0`, we will create `2.304.1`

## Contributions

This is an open source project.
Feel free to open issues and pull requests for improving code and documents.
