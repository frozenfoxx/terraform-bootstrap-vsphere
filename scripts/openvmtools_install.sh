#!/usr/bin/env bash

# Installs open-vm-tools

# Variables
PACKAGES="open-vm-tools perl"

# Logic

apt-get update && \
  apt-get install --yes --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" ${PACKAGES}
