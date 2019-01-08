# Docker nginx proxy deployment for laravel on vps or local
https://github.com/jwilder/nginx-proxy with startssl, nginx, php-fpm, mariadb, composer, node, adminer or phpmyadmin

copy .env.example to .env and set in it you own parametres.

./init - for initialize and start laravel on production

./start - start base, nginx and php fpm containers for already initialized project

./watch - start phpmyadmin, node yarn watch and socat for browsersync ui port redirection

I use it with with https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion
