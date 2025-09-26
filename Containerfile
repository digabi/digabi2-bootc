ARG BASE_IMAGE="quay.io/fedora/fedora-bootc:latest"

FROM scratch AS ctx
COPY build_files/ctx /

FROM ${BASE_IMAGE}
ARG BUILD_REVISION
ARG BUILD_TIMESTAMP

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    ostree container commit

RUN bootc container lint --no-truncate
