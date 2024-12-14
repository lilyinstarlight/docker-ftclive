FROM alpine:latest AS build

ARG VERSION=6.4.1
ARG REVISION=1
ARG CHANNEL=GQLTEUGH
ARG BUILD_DATE=2024-12-14

RUN apk add curl libarchive-tools openjdk21-jre-headless eudev eudev-libs xdg-user-dirs
RUN \
  mkdir -p /src /app && \
  (curl -sSfL https://ftc-scoring.firstinspires.org/local/download/${CHANNEL}/all_platforms -o /src/FTCLive-${VERSION}.zip && \
  bsdtar -xf /src/FTCLive-${VERSION}.zip -C /app --strip-components=1)

RUN env XDG_CONFIG_HOME=/app/config xdg-user-dirs-update --set DOCUMENTS /app/docs

RUN env XDG_CONFIG_HOME=/app/config XDG_DATA_HOME=/app/data XDG_STATE_HOME=/app/state /app/bin/FTCLauncher & while kill -0 %1 &>/dev/null && ! grep -Fq 'INFO  org.usfirst.ftc.server.Server - Server boot id:' /app/state/*/*.log &>/dev/null; do sleep 1; done && kill %1

RUN test -e /app/data/ftclive-*-default/lib/FTCLocal-v${VERSION}.jar || (echo 'ERROR: Version does not match latest for this channel. Please update the Dockerfile.' && exit 1)

FROM alpine:latest

ARG VERSION=6.4.1
ARG REVISION=1
ARG BUILD_DATE=2024-12-14

LABEL maintainer="Lily Foster <lily@lily.flowers>" \
  org.opencontainers.image.created=$BUILD_DATE \
  org.opencontainers.image.authors="FIRST" \
  org.opencontainers.image.url="https://github.com/FIRST-Tech-Challenge/scorekeeper" \
  org.opencontainers.image.documentation="https://www.firstinspires.org/sites/default/files/uploads/resource_library/ftc/scorekeeper-manual.pdf" \
  org.opencontainers.image.source="https://github.com/lilyinstarlight/docker-ftclive" \
  org.opencontainers.image.version=$VERSION \
  org.opencontainers.image.revision=$REVISION \
  org.opencontainers.image.vendor="Lily Foster <lily@lily.flowers>" \
  org.opencontainers.image.licenses="" \
  org.opencontainers.image.title="FIRST Tech Challenge Live" \
  org.opencontainers.image.description="FIRST Tech Challenge Live Scorekeeper Software"

RUN apk add openjdk21-jre-headless eudev eudev-libs xdg-user-dirs

COPY --from=build /app /app

EXPOSE 80

WORKDIR /app/bin

CMD [ "/usr/bin/env", "XDG_CONFIG_HOME=/app/config", "XDG_DATA_HOME=/app/data", "XDG_STATE_HOME=/app/state", "/app/bin/FTCLauncher" ]
