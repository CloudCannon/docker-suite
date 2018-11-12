#!/bin/sh -e

PWD=`pwd`;

echo "docker run -v $PWD/site:/home/circleci/project/ -m 1024M --cpuset-cpus='0' --cpus=1 --rm cloudcannon/suite-development"
docker run -v $PWD/site:/home/circleci/project/ -m 1024M --cpuset-cpus='0' --cpus=1 --rm cloudcannon/suite-development
