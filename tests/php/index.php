<?php

if (extension_loaded('newrelic')) {
  echo "Hello world!";
  phpinfo();
  sleep(2); // make the transaction interesting enough to sample
} else {
  throw new Exception('Failed to load newrelic extension');
}
