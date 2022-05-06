FROM alpine:latest as build

ARG VERSION=3.4.4
ARG REVISION=1
ARG BUILD_DATE=2022-05-06

RUN apk add curl libarchive-tools
RUN \
  mkdir -p /src /app && \
  curl -sSL https://github.com/FIRST-Tech-Challenge/scorekeeper/releases/download/v$VERSION/FIRST-Tech-Challenge-Live-v$VERSION.zip -o /src/FIRST-Tech-Challenge-Live-v$VERSION.zip && \
  bsdtar -xf /src/FIRST-Tech-Challenge-Live-v$VERSION.zip -C /app --strip-components=1

FROM openjdk:17-slim

ARG VERSION=3.4.4
ARG REVISION=1
ARG BUILD_DATE=2022-05-06

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

COPY --from=build /app /app

EXPOSE 80

WORKDIR /app/bin

CMD [ "/app/bin/FTCLocal" ]
