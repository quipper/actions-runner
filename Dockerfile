ARG RUNNER_VERSION=2.316.1

# extends https://github.com/actions/runner/blob/main/images/Dockerfile
FROM ghcr.io/actions/actions-runner:${RUNNER_VERSION}

ARG TARGETOS
ARG TARGETARCH

RUN sudo apt-get update -y \
    && sudo apt-get install -y --no-install-recommends \
        # packages in actions-runner-controller/runner-22.04
        curl \
        git \
        jq \
        unzip \
        zip \
        # packages in actions-runner-controller/runner-20.04
        build-essential \
        locales \
        tzdata \
        # ruby/setup-ruby dependencies
        # https://github.com/ruby/setup-ruby#using-self-hosted-runners
        libyaml-dev \
        # dockerd dependencies
        iptables

# KEEP LESS PACKAGES:
# We'd like to keep this image small for maintanability and security.
# See also,
# https://github.com/actions/actions-runner-controller/pull/2050
# https://github.com/actions/actions-runner-controller/blob/master/runner/actions-runner.ubuntu-22.04.dockerfile

# keep /var/lib/apt/lists to reduce time of apt-get update in a job

# some setup actions store cache into /opt/hostedtoolcache
ENV RUNNER_TOOL_CACHE /opt/hostedtoolcache
RUN sudo mkdir /opt/hostedtoolcache \
    && sudo chown runner:docker /opt/hostedtoolcache

COPY entrypoint.sh /

VOLUME /var/lib/docker

# some setup actions depend on ImageOS variable
# https://github.com/actions/runner-images/issues/345
ENV ImageOS=ubuntu22

# docker-init sends the signal to children
ENV RUNNER_MANUALLY_TRAP_SIG=

# disable the log by default, because it is too large
ENV ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=

ENTRYPOINT ["/usr/bin/docker-init", "--", "/entrypoint.sh"]
CMD ["/home/runner/run.sh"]
