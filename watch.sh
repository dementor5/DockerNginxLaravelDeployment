#!/bin/bash
docker-compose up -d socat
docker-compose up -d phpmyadmin
# docker-compose up -d adminer
docker-compose run --rm --use-aliases node yarn watch
docker-compose stop socat
docker-compose rm -f socat
docker-compose stop phpmyadmin
docker-compose rm -f phpmyadmin
# docker-compose stop adminer
# docker-compose rm -f adminer
