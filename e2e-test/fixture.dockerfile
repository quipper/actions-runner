FROM debian:trixie-20260518 AS builder
WORKDIR /workspace
COPY Makefile /workspace
RUN test -s Makefile

FROM debian:trixie-20260518
WORKDIR /
COPY --from=builder /workspace/Makefile .
RUN test -s Makefile
