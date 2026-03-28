FROM debian:trixie-20260316 AS builder
WORKDIR /workspace
COPY Makefile /workspace
RUN test -s Makefile

FROM debian:trixie-20260316
WORKDIR /
COPY --from=builder /workspace/Makefile .
RUN test -s Makefile
