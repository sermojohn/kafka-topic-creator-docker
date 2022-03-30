FROM bash:3.1.23

ARG KAF_VERSION=0.1.44
ARG TARGETPLATFORM

RUN apk add --no-cache curl \
    && if [[ "$TARGETPLATFORM" = "linux/arm64" ]]; then ARCHITECTURE=arm64; else ARCHITECTURE=x86_64; fi \
    && curl -L https://github.com/birdayz/kaf/releases/download/v${KAF_VERSION}/kaf_${KAF_VERSION}_Linux_${ARCHITECTURE}.tar.gz --output - | gunzip -c | tar xopf - -O kaf >kaf \
    && chmod +x kaf

COPY ./create-kafka-topics.sh /create-kafka-topics.sh

ENTRYPOINT ["bash", "/create-kafka-topics.sh"]
