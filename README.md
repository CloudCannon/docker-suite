# docker-suite

An image that includes everything you need to run CloudCannon suite tasks

## Installing this on circleci

below is the recommended circle configuration:

```yaml
version: 2
jobs:
  build:
    branches:
      only:
        - master

    docker:
      - image: cloudcannon/suite

    working_directory: ~/project

    environment:
      - DOCKER_SCREENSHOTS: true
      - JEKYLL_ENV: production
      - PRODUCTION_BRANCH: production
      - STAGING_BRANCH: master

    steps:
      - checkout

      - restore_cache:
          keys:
            - yarn-cache-{{ checksum "yarn.lock" }}

      - run:
          name: "yarn"
          command: "yarn"

      - save_cache:
          key: yarn-cache-{{ checksum "yarn.lock" }}
          paths:
            - node_modules

      - restore_cache:
          keys:
            - gem-cache-{{ checksum "src/Gemfile.lock" }}

      - run:
          name: "bundle install"
          command: "yarn run gulp dev:install"

      - save_cache:
          key: gem-cache-{{ checksum "src/Gemfile.lock" }}
          paths:
            - src/.bundle
            - vendor/bundle

      - run:
          name: "build jekyll site"
          command: "yarn run gulp dev:build"
```

This is configured with the following options:

- Use the latest version of `cloudcannon/suite` from [DockerHub](https://hub.docker.com/r/cloudcannon/suite/).
- Cache node_modules and bundle installs
- Build jekyll site

---

## Development

### The base image

To build the base image run `./build.sh`.

## Releasing a new version

Ensure you are logged into docker hub using `docker login` then run `docker push cloudcannon/suite`. This will push the locally built version of the docker image.

### Testing locally

This repo includes a build image for testing. This image inherits from the base docker image and runs the dev-cmd script on your site. Use the following commands to run this:

1. Build using `./dev-build.sh`
2. Add your CloudCannon Suite site to `./site`
3. Run using `./dev-run.sh`
4. Configure the commands run in `./dev-cmd.sh`
