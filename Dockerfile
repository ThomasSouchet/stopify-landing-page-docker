FROM alpine:3.13

ENV HOME="/tmp"
RUN apk --no-cache add bash bash-completion ca-certificates libc6-compat libstdc++ tzdata \
 && find /tmp -mindepth 1 -maxdepth 1 | xargs rm -rf \
 && mkdir -p /src /target \
 && chmod a+w /src /target

ADD script/hugo.sh hugo.sh
RUN sh hugo.sh && rm hugo.sh

EXPOSE 1313

WORKDIR /src

ENTRYPOINT ["hugo"]
