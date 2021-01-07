# See https://cloud.docker.com/repository/docker/jdkato/vale
FROM alpine:3.10

# TODO: DITA / XML:
#    openjdk11 \
#    libxslt \
# COPY bin/dita-ot-3.6 /
#
# This currently isn't packaged because it makes the size 7x as big.

# Debug shell: $ docker run -it --entrypoint /bin/sh jdkato/vale -s

RUN apk add --no-cache --update \
    py3-docutils \
    asciidoctor

COPY bin/vale /bin

ENV PATH="/bin:/dita-ot-3.6/bin:$PATH"
ENTRYPOINT ["/bin/vale"]
