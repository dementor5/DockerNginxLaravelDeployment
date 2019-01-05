#!/bin/bash
docker-compose up -d mariadb
docker-compose up -d fpm
docker-compose up -d nginx
