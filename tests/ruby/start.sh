#!/bin/sh

# Start ruby app and provide time to boot Puma
ruby app.rb & sleep 5

# Make requests
while true; do
  curl http://0.0.0.0:4567
  sleep 3
done
