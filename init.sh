#!/bin/bash
ROOT_PATH=$(dirname $(readlink -e $0))
if [ ! -f $ROOT_PATH/.env ]; then
  echo '.env doesnt exist! Copy .env.example to .env and set your parameters in it. Then start this script again'
  exit 1
fi

. .env
if [ ! -d $PROJECT_DIRECTORY ]; then
  echo 'project directory doesnt exist!'
  exit 1
fi

if [ $IS_PRODUCTION == true ]; then
  CONFIG="-f docker-compose.yml -f docker-compose.production.yml"
else
  CONFIG="-f docker-compose.yml"
fi

CURRENT_UID="$(id -u):$(id -g)"
sed -ri -e "s/^CURRENT_UID=.*/CURRENT_UID=$CURRENT_UID/g" $ROOT_PATH/.env

PROJECT_DIRECTORY=$ROOT_PATH/$PROJECT_DIRECTORY
cp $PROJECT_DIRECTORY/.env.example                        $PROJECT_DIRECTORY/.env
sed -ri -e "s/^DB_HOST=.*/DB_HOST=$DB_HOST/g"             $PROJECT_DIRECTORY/.env
sed -ri -e "s/^DB_DATABASE=.*/DB_DATABASE=$DB_DATABASE/g" $PROJECT_DIRECTORY/.env
sed -ri -e "s/^DB_USERNAME=.*/DB_USERNAME=$DB_USERNAME/g" $PROJECT_DIRECTORY/.env
sed -ri -e "s/^DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/g" $PROJECT_DIRECTORY/.env

if [ ! -d $ROOT_PATH/$DB_DIRECTORY ]; then
  mkdir $ROOT_PATH/$DB_DIRECTORY
fi

docker-compose $CONFIG up -d mariadb
docker-compose $CONFIG run --rm composer bash -c 'composer install && php artisan key:generate'
docker-compose $CONFIG run --rm node bash -c 'yarn && yarn prod'
docker-compose $CONFIG up -d fpm
docker-compose $CONFIG up -d nginx
docker-compose $CONFIG exec fpm php artisan migrate:refresh --seed
# docker-compose $CONFIG exec fpm php artisan command:sync
