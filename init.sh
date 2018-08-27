#!/bin/bash
init () {
  docker-compose down
  CURRENT_UID="$(id -u):$(id -g)"
  sed -ri -e "s/^CURRENT_UID=.*/CURRENT_UID=$CURRENT_UID/g" $ROOT_PATH/.env
  . .env
  PROJECT_DIRECTORY=$ROOT_PATH/$PROJECT_DIRECTORY
  cp $PROJECT_DIRECTORY/.env.example                        $PROJECT_DIRECTORY/.env
  sed -ri -e "s/^DB_HOST=.*/DB_HOST=$DB_HOST/g"             $PROJECT_DIRECTORY/.env
  sed -ri -e "s/^DB_DATABASE=.*/DB_DATABASE=$DB_DATABASE/g" $PROJECT_DIRECTORY/.env
  sed -ri -e "s/^DB_USERNAME=.*/DB_USERNAME=$DB_USERNAME/g" $PROJECT_DIRECTORY/.env
  sed -ri -e "s/^DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/g" $PROJECT_DIRECTORY/.env
  if [ ! -d $ROOT_PATH/$DB_DIRECTORY ]; then
    mkdir $ROOT_PATH/$DB_DIRECTORY
  fi
  docker-compose up -d db
  docker-compose up composer
  docker-compose up node
  docker-compose up -d app
  docker-compose exec app bash -c "php artisan key:generate \
                                   && php artisan migrate:refresh --seed"
  docker-compose up -d web
  docker-compose up -d adminer
  docker-compose exec app php artisan command:sync
}

ROOT_PATH=$(dirname $(readlink -e $0))

if [ -f $ROOT_PATH/.env ]; then
  init
else
  echo 'Copy .env.example to .env and set your parameters in it. Then start this script again'
fi
