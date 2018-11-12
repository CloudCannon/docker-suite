#!/bin/sh -e

echo "docker build -t cloudcannon/suite-development -f ./Dockerfile-dev ."
docker build -t cloudcannon/suite-development -f ./Dockerfile-dev .
