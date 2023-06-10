FROM debian:stable as builder
WORKDIR /workspace
COPY Makefile /workspace
RUN test -s Makefile

FROM debian:stable
WORKDIR /
COPY --from=builder /workspace/Makefile .
RUN test -s Makefile
