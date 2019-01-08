#!/bin/bash

ROOT_PATH=$(dirname $(readlink -e $0))

if [ ! -f $ROOT_PATH/.env ]; then
  echo '.env doesnt exist! Copy .env.example to .env and set your parameters in it. Then start this script again'
  exit 1
fi

. .env

if [ $IS_PRODUCTION == true ]; then
  CONFIG="-f docker-compose.yml -f docker-compose.production.yml"
else
  CONFIG="-f docker-compose.yml"
fi

docker-compose $CONFIG up -d socat
docker-compose $CONFIG up -d phpmyadmin
# docker-compose $CONFIG up -d adminer
docker-compose $CONFIG run --rm --use-aliases node yarn watch
docker-compose $CONFIG stop socat
docker-compose $CONFIG rm -f socat
docker-compose $CONFIG stop phpmyadmin
docker-compose $CONFIG rm -f phpmyadmin
# docker-compose $CONFIG stop adminer
# docker-compose $CONFIG rm -f adminer
