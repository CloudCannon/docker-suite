#!/bin/sh -e

cd project

yarn
# yarn run gulp dev:install
# yarn run gulp dev:build

yarn run gulp g11n-upload
