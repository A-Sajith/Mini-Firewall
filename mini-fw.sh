#!/usr/bin/env bash

TABLE="mini_fw"
CHAIN="input_filter"

case "$1" in
  init)
    nft add table inet $TABLE
    nft add chain inet $TABLE $CHAIN '{ type filter hook input priority 0 ; policy accept ; }'
    echo "Firewall initialisé."
    ;;

  block-ip)
    nft add rule inet $TABLE $CHAIN ip saddr "$2" drop
    echo "IP $2 bloquée."
    ;;

  unblock-ip)
    handle=$(nft -a list chain inet $TABLE $CHAIN | grep "$2" | grep -oP 'handle \K[0-9]+')
    nft delete rule inet $TABLE $CHAIN handle $handle
    echo "IP $2 débloquée."
    ;;

  list)
    nft list chain inet $TABLE $CHAIN
    ;;

  *)
    echo "Usage: $0 {init|block-ip <ip>|unblock-ip <ip>|list}"
    ;;
esac
