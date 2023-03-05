FROM docker:23.0.1-dind

ENV DOCKER_HOST=unix:///var/run/docker.sock
ENV TINI_SUBREAPER=1

RUN apk add --no-cache uuidgen

RUN mkdir "/app"
COPY app/ /app

COPY --link entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

WORKDIR /app

ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD ["default"]
