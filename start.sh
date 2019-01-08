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

docker-compose $CONFIG up -d mariadb
docker-compose $CONFIG up -d fpm
docker-compose $CONFIG up -d nginx
