FROM php:fpm

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt update \
  && apt install --no-install-recommends -y \
  apt-utils \
  && apt dist-upgrade -y \
  && rm -rf /var/lib/at/lists/* \
  && docker-php-ext-install pdo_mysql \
  && useradd -ms /bin/bash user \
