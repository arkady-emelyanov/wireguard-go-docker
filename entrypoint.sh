#!/bin/bash

finish () {
    wg-quick down /etc/wireguard/wg0.conf
    exit 0
}
trap finish SIGTERM SIGINT SIGQUIT

# install interface
if ! wg-quick up /etc/wireguard/wg0.conf; then
  exit 1
fi

tail -f /dev/null
