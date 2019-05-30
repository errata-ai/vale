FROM alpine:3.7

RUN apk add --update \
    python \
    py-pip \
    asciidoctor \
  && pip install docutils \
  && rm -rf /var/cache/apk/*

COPY bin/vale /
ENTRYPOINT ["/vale"]
