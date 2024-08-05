<?php

if (extension_loaded('newrelic')) {
  echo "Hello world!";
  phpinfo();
} else {
  throw new Exception('Failed to load newrelic extension');
}
