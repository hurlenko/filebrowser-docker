FROM alpine as builder

ARG VERSION

COPY get.sh get.sh

RUN apk add --virtual=build-dependencies \
    bash \
    && ./get.sh $VERSION \
    && apk del --purge build-dependencies

FROM alpine as runtime

ARG BUILD_DATE
ARG VCS_REF

ENV DOMAIN=0.0.0.0:8080
ENV ARIA2RPCPORT=8080

LABEL maintainer="hurlenko" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.name="filebrowser" \
    org.label-schema.description="Web File Browser which can be used as a middleware or standalone app. " \
    org.label-schema.version=$VERSION \
    org.label-schema.url="https://github.com/hurlenko/filebrowser-docker" \
    org.label-schema.license="MIT" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/hurlenko/filebrowser-docker" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vendor="hurlenko" \
    org.label-schema.schema-version="1.0"

COPY --from=builder /usr/local/bin/filebrowser /filebrowser/filebrowser

VOLUME /srv
EXPOSE 80

ENTRYPOINT ["/filebrowser/filebrowser"]