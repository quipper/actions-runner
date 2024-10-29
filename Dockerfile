ARG RUNNER_VERSION=2.320.0

# extends https://github.com/actions/runner/blob/main/images/Dockerfile
FROM ghcr.io/actions/actions-runner:${RUNNER_VERSION}

ARG TARGETOS
ARG TARGETARCH

# DO NOT ADD ANY PACKAGE!
# We'd like to keep this image small for long-term maintanability and security.
# If you want to install a package, use https://aquaproj.github.io in your workflow.

RUN sudo apt-get update -y \
    && sudo apt-get install -y --no-install-recommends \
        # Packages in actions-runner-controller/runner-22.04
        # https://github.com/actions/actions-runner-controller/pull/2050
        # https://github.com/actions/actions-runner-controller/blob/master/runner/actions-runner.ubuntu-22.04.dockerfile
        curl \
        git \
        jq \
        unzip \
        zip \
        # Packages in actions-runner-controller/runner-20.04
        build-essential \
        locales \
        tzdata \
        # ruby/setup-ruby dependencies
        # https://github.com/ruby/setup-ruby#using-self-hosted-runners
        libyaml-dev \
        # dockerd dependencies
        iptables \
    # Remove the extra repository to reduce time of apt-get update
    && sudo add-apt-repository -r ppa:git-core/ppa \
    && sudo rm -rf /var/lib/apt/lists/*

# Some setup actions store cache into /opt/hostedtoolcache
ENV RUNNER_TOOL_CACHE=/opt/hostedtoolcache
RUN sudo mkdir /opt/hostedtoolcache \
    && sudo chown runner:docker /opt/hostedtoolcache

COPY entrypoint.sh /

VOLUME /var/lib/docker

# docker-init sends the signal to children
ENV RUNNER_MANUALLY_TRAP_SIG=

# Disable the log by default, because it is too large
ENV ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=

# Align to GitHub-hosted runners (ubuntu-latest)
ENV LANG=C.UTF-8

ENTRYPOINT ["/usr/bin/docker-init", "--", "/entrypoint.sh"]
CMD ["/home/runner/run.sh"]
