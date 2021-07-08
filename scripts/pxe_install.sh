#!/usr/bin/env bash

# Installs PXE Linux files

# Variables
DATAROOT=${DATAROOT:-"/data"}
DISTRO=${DISTRO:-'ubuntu'}
RELEASE=${RELEASE:-'bionic'}

# Functions

## Choose which distro to install
install_pxelinux()
{
  if [[ ${DISTRO} == 'ubuntu' ]]; then
    install_pxelinux_ubuntu
  else
    echo "This distro is not supported at this time."
    exit 1
  fi
}

## Install pxelinux for Ubuntu
install_pxelinux_ubuntu()
{
  # Set up the tftp directory
  mkdir -p ${DATAROOT}/tftp

  # Pull the netboot image and unroll
  wget -O /tmp/netboot.tar.gz http://archive.ubuntu.com/ubuntu/dists/${RELEASE}-updates/main/installer-amd64/current/legacy-images/netboot/netboot.tar.gz
  tar xvzf /tmp/netboot.tar.gz --directory ${DATAROOT}/tftp/
  rm /tmp/netboot.tar.gz
}

# Display usage information
usage()
{
  echo "Usage: [Environment Variables] ./pxe_install.sh [options]"
  echo "  Environment Variables:"
  echo "    DATAROOT               path for data serving (default: '/data')"
  echo "    DISTRO                 Linux distro to serve (default: 'ubuntu')"
  echo "    RELEASE                release of the distro (default: 'bionic')"
  echo "  Options:"
  echo "    -h | --help            display this usage information"
  echo "    --dataroot             set the data root (override environment variable if present)"
  echo "    --distro               Linux distro to serve (override environment variable if present)"
  echo "    --release              release of the distro (override environment variable if present)"
}

# Logic

## Argument parsing
while [[ "$#" > 1 ]]; do
  case $1 in
    --dataroot )  DATAROOT="$2"
                  ;;
    --distro )    DISTRO="$2"
                  ;;
    --release )   RELEASE="$2"
                  ;;
    -h | --help ) usage
                  exit 0
  esac
  shift
done

install_pxelinux
