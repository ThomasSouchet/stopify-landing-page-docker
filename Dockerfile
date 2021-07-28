FROM alpine:3.13

COPY website /website

ENV HOME="/tmp"
RUN apk --no-cache add bash bash-completion ca-certificates libc6-compat libstdc++ tzdata \
 && find /tmp -mindepth 1 -maxdepth 1 | xargs rm -rf \
 && mkdir -p /src /target \
 && chmod a+w /src /target

ADD script/hugo.sh hugo.sh
RUN sh hugo.sh && rm hugo.sh

EXPOSE 1313

WORKDIR /src

CMD ["hugo", "server", "--bind=0.0.0.0", "--port=1313", "--destination=src", "--source=/website", "--baseURL=http://localhost:1313"]
