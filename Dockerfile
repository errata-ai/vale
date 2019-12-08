FROM alpine:3.7

# TODO: Install DITA-related deps
#
# See https://cloud.docker.com/repository/docker/jdkato/vale
RUN apk add --no-cache --update \
    python3 \
    asciidoctor \
    && pip3 install docutils

COPY bin/vale /bin
# Compatibility
COPY bin/vale /

ENV PATH="/bin:${PATH}"
ENTRYPOINT ["/bin/vale"]
