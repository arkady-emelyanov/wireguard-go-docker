## build container
FROM golang:1.13-alpine3.11 as builder

ARG wg_go_tag=v0.0.20200121
ARG wg_tools_tag=v1.0.20200121
RUN apk add --update git build-base libmnl-dev iptables

RUN git clone https://git.zx2c4.com/wireguard-go && \
    cd wireguard-go && \
    git checkout $wg_go_tag && \
    make && \
    make install

ENV WITH_WGQUICK=yes
RUN git clone https://git.zx2c4.com/wireguard-tools && \
    cd wireguard-tools && \
    git checkout $wg_tag && \
    cd src && \
    make && \
    make install

## target container
FROM alpine:3.11
RUN apk add --no-cache --update bash libmnl iptables

COPY --from=builder /usr/bin/wireguard-go /usr/bin/wg* /usr/bin/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
