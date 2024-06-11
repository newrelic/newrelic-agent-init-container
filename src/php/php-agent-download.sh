#!/bin/sh

libc=$1
version=$2

if [[ -z "$libc" ]]; then
  echo "'libc' argument not supplied. Defaulting to 'glibc'"
  libc="glibc"
elif [[ "$libc" != "glibc" && "$libc" != "musl" ]]; then
  echo "error: invalid 'libc' argument provided. Exiting."
  exit 1
fi

if [[ -z "$version" ]]; then
  latest=$(wget https://download.newrelic.com/php_agent/release/ -O - | grep newrelic-php5 | cut -d '-' -f 3 | head -n 1)
  url="https://download.newrelic.com/php_agent/release/newrelic-php5-${latest}-linux"
else
  url="https://download.newrelic.com/php_agent/archive/${version}/newrelic-php5-${version}-linux"
fi

if [ "$libc" = 'musl' ]; then
  url="${url}-musl.tar.gz"
else
  url="${url}.tar.gz"
fi

# echo "url: $url"
wget -c ${url} -O - | tar -xz --strip-components 1
