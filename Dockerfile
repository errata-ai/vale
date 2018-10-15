FROM scratch
COPY vale /
ENTRYPOINT ["vale"]