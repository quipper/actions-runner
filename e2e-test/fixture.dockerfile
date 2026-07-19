FROM debian:13 AS builder
WORKDIR /workspace
COPY Makefile /workspace
RUN test -s Makefile

FROM debian:13
WORKDIR /
COPY --from=builder /workspace/Makefile .
RUN test -s Makefile
