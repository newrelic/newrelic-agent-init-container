ARG PHP_IMAGE_TAG
FROM php:$PHP_IMAGE_TAG
WORKDIR /usr/src/myapp

# Add test app
COPY index.php .

EXPOSE 8000
ENTRYPOINT ["php", "-S", "0.0.0.0:8000"]
