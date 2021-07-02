#!/usr/bin/env bash

# Installs dnsmasq

# Variables
DATAROOT=${DATAROOT:-"/data"}
DHCPSTART=${DHCPSTART:-'192.168.3.10'}
DHCPSTOP=${DHCPSTOP:-'192.168.3.19'}
DOMAIN=${DOMAIN:-"churchoffoxx.net"}
GATEWAY=${GATEWAY:-'192.168.3.1'}
HOSTIP=${HOSTIP:-$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)}
HOSTNAME=$(hostname)
PACKAGE="dnsmasq"

# Functions

## Configure dnsmasq
configure_dnsmasq()
{
  echo "Configuring dnsmasq..."

  # Create tftp upload directory if it doesn't exist yet
  if ! [[ -d ${DATAROOT}/tftp ]]; then
    echo "${DATAROOT}/tftp directory not detected, creating..."
    mkdir -p ${DATAROOT}/tftp
  fi

  # Set the DHCPRANGE
  DHCPRANGE="${DHCPSTART},${DHCPSTOP},5m"

  # Create dnsmasq.conf
  (
  cat <<EOF
interface=ens160
bind-interfaces

domain=${DOMAIN}
expand-hosts
dhcp-option=3,${GATEWAY}
dhcp-option=6,${HOSTIP}
dhcp-range=${DHCPRANGE}
dhcp-boot=pxelinux.0
dhcp-authoritative
dhcp-leasefile=/var/lib/misc/dnsmasq.lease

enable-tftp
tftp-root=${DATAROOT}/tftp

log-queries
log-dhcp

EOF
  ) > /etc/dnsmasq.conf
}

## If applicable, disable resolved
disable_resolved()
{
  echo "Disable resolved..."

  sudo systemctl disable systemd-resolved
  sudo systemctl mask systemd-resolved
}

## Install dnsmasq
install_dnsmasq()
{
  apt-get update && \
    apt-get install --yes --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" ${PACKAGE}
}

## Restart dnsmasq
restart_dnsmasq()
{
  echo "Restarting dnsmasq..."
  systemctl restart dnsmasq 
}

# Display usage information
usage()
{
  echo "Usage: [Environment Variables] ./dnsmasq_install.sh [options]"
  echo "  Environment Variables:"
  echo "    DATAROOT               path for data serving (default: '/data')"
  echo "    DHCPSTART              IP to start DHCP serving (default: '192.168.3.10')"
  echo "    DHCPSTOP               IP to stop DHCP serving (default: '192.168.3.19')"
  echo "    DOMAIN                 domain to serve from (default: 'churchoffoxx.net')"
  echo "    GATEWAY                IP to use as a gateway (default: '192.168.3.1')"
  echo "    HOSTIP                 IP to resolve for bootstrap (default: dynamic pull from ip for eth0)"
  echo "  Options:"
  echo "    -h | --help            display this usage information"
  echo "    --dataroot             set the data root (override environment variable if present)"
  echo "    --dhcpstart            set the DHCP start IP range (override environment variable if present)"
  echo "    --dhcpstop             set the DHCP stop IP range (override environment variable if present)"
  echo "    --domain               domain to serve from (override environment variable if present)"
  echo "    --gateway              IP to use as a gateway (override environment variable if present)"
  echo "    --hostip               IP to resolve for bootstrap (override environment variable if present)"
}


# Logic

## Argument parsing
while [[ "$#" > 1 ]]; do
  case $1 in
    --dataroot )  DATAROOT="$2"
                  ;;
    --dhcpstart ) DHCPSTART="$2"
                  ;;
    --dhcpstop  ) DHCPSTOP="$2"
                  ;;
    --domain )    DOMAIN="$2"
                  ;;
    --gateway )   GATEWAY="$2"
                  ;;
    --hostip )    HOSTIP="$2"
                  ;;
    -h | --help ) usage
                  exit 0
  esac
  shift
done

install_dnsmasq
configure_dnsmasq
disable_resolved
restart_dnsmasq
