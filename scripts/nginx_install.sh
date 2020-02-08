#!/usr/bin/env bash

# Installs nginx with serving static content

# Variables
DATAROOT=${DATAROOT:-"/data"}
PACKAGE="nginx"
SERVERNAME=${SERVERNAME:-"bootstrap.churchoffoxx.net"}

# Functions

## Configure nginx
configure_nginx()
{
  echo "Configuring nginx..."

  # Create site configuration
  (
    cat <<EOF
server {
  listen 80 default_server;
  listen [::]:80 default_server;

  root ${DATAROOT};

  index index.html;

  server_name ${SERVERNAME};

  location / {
    try_files \$uri \$uri/ =404;
    sendfile on;
  }
}
EOF
  ) > /etc/nginx/sites-available/${SERVERNAME}

  echo "Making the site available..."
  ln -s /etc/nginx/sites-available/${SERVERNAME} /etc/nginx/sites-enabled/${SERVERNAME}
}

## Configure webroot
configure_webroot()
{
  echo "Creating ${DATAROOT}..."
  mkdir -p "${DATAROOT}"
}

## Disable default site
disable_default()
{
  echo "Disabling the default site..."
  if [[ -f /etc/nginx/sites-enabled/default ]]; then
    rm /etc/nginx/sites-enabled/default
  fi
}

## Install nginx
install_nginx()
{
  apt-get update && \
    apt-get install --yes --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" ${PACKAGE}
}

# Display usage information
usage()
{
  echo "Usage: [Environment Variables] ./nginx_install.sh [options]"
  echo "  Environment Variables:"
  echo "    DATAROOT               path for file serving (default: '/data')"
  echo "  Options:"
  echo "    -h | --help            display this usage information"
  echo "    --dataroot             set the file root (override environment variable if present)"
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

install_nginx
configure_webroot
configure_nginx
disable_default
systemctl restart ${PACKAGE}
systemctl enable ${PACKAGE}
