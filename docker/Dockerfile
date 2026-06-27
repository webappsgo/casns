# syntax=docker/dockerfile:1

ARG BUILDER_IMAGE=casjaysdev/go:latest
ARG RUNTIME_IMAGE=alpine:latest

FROM ${BUILDER_IMAGE} AS builder

WORKDIR /app

COPY go.mod go.sum* ./

RUN go mod download

COPY src/ ./src/

ARG VERSION=dev

RUN CGO_ENABLED=0 GOFLAGS=-buildvcs=false go build \
    -ldflags="-s -w -X main.version=${VERSION}" \
    -o /app/casns \
    ./src/

FROM ${RUNTIME_IMAGE}

RUN apk add --no-cache \
    bash \
    curl \
    git \
    tor \
    tini

COPY --from=builder /app/casns /usr/local/bin/casns

COPY docker/rootfs/ /

RUN chmod +x /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/casns

EXPOSE 53/tcp 53/udp 80 443 853 784 8853

VOLUME ["/config/casns", "/data/casns"]

STOPSIGNAL SIGRTMIN+3

ENTRYPOINT ["tini", "-p", "SIGTERM", "--", "/usr/local/bin/entrypoint.sh"]
