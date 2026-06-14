FROM debian:trixie-20260610 AS builder
WORKDIR /workspace
COPY Makefile /workspace
RUN test -s Makefile

FROM debian:trixie-20260610
WORKDIR /
COPY --from=builder /workspace/Makefile .
RUN test -s Makefile
