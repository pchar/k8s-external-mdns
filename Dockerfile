# docker build -t quay.io/pch/external-dns:latest .
FROM golang:1.10 as builder
WORKDIR /go/src/github.com/kubernetes-incubator/external-dns
RUN git clone --depth 1 https://github.com/tsaarni/external-dns-hosts-provider-for-mdns . && \
    make dep && \
    GOOS=linux GOARCH=arm64 make build

FROM arm64v8/alpine:latest
COPY --from=builder /go/src/github.com/kubernetes-incubator/external-dns/build/external-dns /bin/external-dns
ENTRYPOINT ["/bin/external-dns"]
