#!/usr/bin/env bash

# Installs NFS

# Variables
DATAROOT=${DATAROOT:-"/data"}
PACKAGES="nfs-kernel-server"

# Functions

## Configures NFS server
configure_nfs()
{
  # Configure the share
  echo "${DATAROOT}/nfs  *(ro,sync,no_wdelay,insecure_locks,no_root_squash,insecure,no_subtree_check)" >> /etc/exports

  # Export the share
  exportfs -a
}

## Install nfs packages
install_nfs()
{
  apt-get update && \
    apt-get install --yes --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" ${PACKAGES}

  # Set up the nfs directory
  mkdir -p ${DATAROOT}/nfs
}

# Display usage information
usage()
{
  echo "Usage: [Environment Variables] ./nfs_install.sh [options]"
  echo "  Environment Variables:"
  echo "    DATAROOT               path for data serving (default: '/data')"
  echo "  Options:"
  echo "    -h | --help            display this usage information"
  echo "    --dataroot             set the data root (override environment variable if present)"
}

# Logic

## Argument parsing
while [[ "$#" > 1 ]]; do
  case $1 in
    --dataroot )  DATAROOT="$2"
                  ;;
    -h | --help ) usage
                  exit 0
  esac
  shift
done

install_nfs
configure_nfs
