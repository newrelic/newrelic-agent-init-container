#!/bin/sh

# Start ruby app and provide time to boot Puma
bundle exec rackup & sleep 5

# Hit endponint
while true; do
  curl http://0.0.0.0:4567
  sleep 3
done
