# See https://cloud.docker.com/repository/docker/jdkato/vale
FROM alpine:3.10

RUN apk add --no-cache --update \
    libxslt \
    wget \
    unzip \
    py3-sphinx \
    asciidoctor

RUN wget https://github.com/dita-ot/dita-ot/releases/download/3.4/dita-ot-3.4.zip
RUN unzip dita-ot-3.4.zip > /dev/null 2>&1

COPY bin/vale /bin

ENV PATH="/bin:/dita-ot-3.4/bin:${PATH}"
ENTRYPOINT ["/bin/vale"]
