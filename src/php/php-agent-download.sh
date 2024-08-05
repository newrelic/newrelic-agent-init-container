#!/bin/bash

libc=$1
version=$2

if [ -z "$libc" ]; then
  echo "'libc' argument not supplied. Defaulting to 'gnu'"
  libc="gnu"
elif [[ ! $libc =~ ^(musl|gnu)$ ]]; then
  echo "error: invalid 'libc' argument provided. Exiting."
  exit 1
fi

if [ -z "$version" ]; then
  latest=$(curl https://download.newrelic.com/php_agent/release/ | grep newrelic-php5 | cut -d '-' -f 3 | head -n 1)
  url="https://download.newrelic.com/php_agent/release/newrelic-php5-${latest}-linux"
else
  url="https://download.newrelic.com/php_agent/archive/${version}/newrelic-php5-${version}-linux"
fi

if [ "$libc" = 'musl' ]; then
  url+="-musl.tar.gz"
else
  url+=".tar.gz"
fi

# echo "url: $url"
wget -c ${url} -O - | tar -xz --strip-components 1
