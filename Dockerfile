FROM curlimages/curl:7.82.0 AS builder

ARG KAF_VERSION=0.1.44
ARG TARGETPLATFORM

# https://github.com/docker/docker.github.io/blob/master/develop/develop-images/dockerfile_best-practices.md#using-pipes
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN if [[ "$TARGETPLATFORM" = "linux/arm64" ]]; then ARCHITECTURE=arm64; else ARCHITECTURE=x86_64; fi \
    && curl -sL https://github.com/birdayz/kaf/releases/download/v${KAF_VERSION}/kaf_${KAF_VERSION}_Linux_${ARCHITECTURE}.tar.gz --output - | gunzip -c | tar xopf - -O kaf >/tmp/kaf \
    && chmod +x /tmp/kaf

FROM bash:4.4.23

LABEL org.opencontainers.image.url="https://github.com/sermojohn/kafka-topic-creator-docker"
LABEL org.opencontainers.image.source="https://github.com/sermojohn/kafka-topic-creator-docker"
LABEL org.opencontainers.image.authors="ioannis@codebgp.com"
LABEL org.opencontainers.image.version="v0.1.2"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.base.name="docker.io/bash:4.4.23"

ENV KAFKA_HOST=""
ENV KAFKA_PORT=9092
ENV CREATE_TOPICS=""

COPY --from=builder /tmp/kaf /kaf
COPY ./create-kafka-topics.sh /create-kafka-topics.sh

ENTRYPOINT ["bash", "/create-kafka-topics.sh"]
