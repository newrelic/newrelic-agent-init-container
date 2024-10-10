<?php

if (extension_loaded('newrelic')) {
  echo "Hello world!";
  phpinfo();
  $linking_md = newrelic_get_linking_metadata();
  $payload = json_encode($linking_md);
  sleep(10); // make the transaction interesting enough to sample
} else {
  throw new Exception('Failed to load newrelic extension');
}
