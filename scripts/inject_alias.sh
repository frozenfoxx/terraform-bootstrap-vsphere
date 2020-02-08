#!/usr/bin/env bash

# Logic

# Find the hostname line and append bootstrap to it, then install
sed /$(hostname)/'s/$/ bootstrap/g' /etc/hosts > /tmp/new_hosts && \
  mv /tmp/new_hosts /etc/hosts