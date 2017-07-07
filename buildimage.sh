#!/bin/bash

docker rmi --force eborges/phpfpm7.1:latest
docker build -t eborges/phpfpm7.1 .
