# Happier server + embedded web app for Railway.
# Official image, pinned by version and digest: relay-server "stable" build of server-v0.2.21 (commit e992e049ffa7).
FROM happierdev/relay-server:stable-e992e049ffa7@sha256:3617122569179268e8015718ddc2fbb4642fa5461b87e68238e656613929fd63

# Upstream's "full flavor": external Postgres (Railway), uploads on the local volume at /data, one process.
ENV HAPPIER_SERVER_FLAVOR=full \
    HAPPY_SERVER_FLAVOR=full \
    HAPPIER_DB_PROVIDER=postgres \
    HAPPY_DB_PROVIDER=postgres \
    HAPPIER_FILES_BACKEND=local \
    HAPPY_FILES_BACKEND=local \
    HAPPIER_SERVER_LIGHT_DATA_DIR=/data \
    HAPPY_SERVER_LIGHT_DATA_DIR=/data \
    HAPPIER_SENTRY_USE_CENTRAL_DSN=0 \
    METRICS_ENABLED=false \
    PORT=3005

COPY --chmod=0755 start.sh /usr/local/bin/happier-railway-start

# Starts as root only to fix the volume's ownership; the script drops to the image's `happier` user.
USER root
EXPOSE 3005
CMD ["/usr/local/bin/happier-railway-start"]
