# See https://cloud.docker.com/repository/docker/jdkato/vale
FROM --platform=$BUILDPLATFORM golang:1.21-alpine AS build

# TODO: DITA / XML:
#    openjdk11 \
#    libxslt \
# COPY bin/dita-ot-3.6 /
#
# This currently isn't packaged because it makes the size 7x as big.

# Debug shell: $ docker run -it --entrypoint /bin/sh jdkato/vale -s

RUN apk add build-base

COPY . /app/
WORKDIR /app

ENV CGO_ENABLED=1

ARG ltag
ARG TARGETOS TARGETARCH

RUN GOOS=$TARGETOS GOARCH=$TARGETARCH go build -ldflags "-s -w -X main.version=$ltag" -o /app/vale ./cmd/vale

FROM alpine

RUN apk add --no-cache \
    py3-docutils \
    asciidoctor

COPY --from=build /app/vale /bin

# ENV PATH="/bin:/dita-ot-3.6/bin:$PATH"
ENTRYPOINT ["/bin/vale"]
