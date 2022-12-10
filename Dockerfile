# See https://cloud.docker.com/repository/docker/jdkato/vale
FROM --platform=$BUILDPLATFORM golang:1.18-alpine AS build

# TODO: DITA / XML:
#    openjdk11 \
#    libxslt \
# COPY bin/dita-ot-3.6 /
#
# This currently isn't packaged because it makes the size 7x as big.

# Debug shell: $ docker run -it --entrypoint /bin/sh jdkato/vale -s

COPY . /app/
WORKDIR /app

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags '-s -w' -o /app/app ./cmd/vale

FROM alpine

RUN apk add --no-cache --update \
    py3-docutils \
    asciidoctor

COPY --from=build /app/app /bin

# ENV PATH="/bin:/dita-ot-3.6/bin:$PATH"
ENTRYPOINT ["/bin/vale"]
