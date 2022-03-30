FROM bash:3.1.23

ARG KAF_VERSION=0.1.44

RUN apk add --no-cache curl && \
    curl -Ls https://github.com/birdayz/kaf/releases/download/v${KAF_VERSION}/kaf_${KAF_VERSION}_Linux_x86_64.tar.gz --output - | gunzip -c | tar xopf - -O kaf >kaf && chmod +x kaf

COPY ./kaf /kaf
COPY ./create-kafka-topics.sh /create-kafka-topics.sh

ENTRYPOINT ["bash", "/create-kafka-topics.sh"]
