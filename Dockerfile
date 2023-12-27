# syntax=docker/dockerfile:1
FROM golang:1.21.5-alpine as builder
RUN apk add --no-cache make gcc musl-dev linux-headers git
WORKDIR /go-ethereum
ADD ./ ./
RUN --mount=type=cache,target=/go/pkg/mod --mount=type=cache,target=/root/.cache/go-build make geth

FROM alpine:3.18.5
RUN apk add --no-cache ca-certificates jq curl
COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/
EXPOSE 8545 8546 8547
COPY --chmod=775 ./geth.sh ./
ENTRYPOINT ["./geth.sh"]
