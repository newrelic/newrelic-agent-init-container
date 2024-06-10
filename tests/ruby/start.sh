#!/bin/sh

# Start ruby app and provide time to boot Puma
rails s & sleep 5

# Hit endponint
while true; do
  curl http://0.0.0.0:3000
  sleep 3
done
