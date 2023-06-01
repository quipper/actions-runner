# quipper/actions-runner [![build](https://github.com/quipper/actions-runner/actions/workflows/build.yaml/badge.svg)](https://github.com/quipper/actions-runner/actions/workflows/build.yaml)

This is a general-purpose container image of self-hosted runners in GitHub Actions.
It is designed for RunnerScaleSets.

## Purpose

This extends the official image of [actions/runner](https://github.com/actions/runner) to solve the following issues:

- GitHub does not provide a multi-architectures image.
  We cannot run a job on arm64 nodes until [actions/runner#2630](https://github.com/actions/runner/pull/2630) is accepted.
- GitHub does not provide an image which includes both runner and dockerd.
  It is desired to run both in same container for the resource efficiency in Kubernetes node.

As well as we add some packages for our workflows.
We'd like to keep the image small as possible.
DO NOT add any package unless we really need it.

For long-term maintainability and security,

- Align to the official image
- Less image size as possible
- Less logic as possible

## Release

When a new version of actions/runner is released,

1. Renovate creates a pull request
2. GitHub Actions automatically regenerates the Dockerfile from [upstream](https://github.com/actions/runner/blob/main/images/Dockerfile)
3. We will merge it and then [create a new release](https://github.com/quipper/actions-runner/releases)

Here is the versioning policy.

- Use same version as the upstream, such as `2.304.0`
- If we have added a change, increment the patch version. For example, if the upstream is `2.304.0`, we will create `2.304.1`

## Contributions

This is an open source project.
Feel free to open issues and pull requests for improving code and documents.
