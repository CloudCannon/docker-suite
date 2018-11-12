# https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md
# Pull base image.
FROM circleci/ruby:2.3.3

LABEL maintainer="george@cloudcannon.com"

USER root

# Install node
RUN \
  apt-get update && \
  apt-get install -yq curl && \
  curl -sL https://deb.nodesource.com/setup_10.x | bash && \
  apt-get install -yq gcc g++ make nodejs && \
  rm -rf /var/lib/apt/lists/*

# Install yarn
RUN \
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && \
  apt-get install -yq yarn && \
  rm -rf /var/lib/apt/lists/*

# See https://crbug.com/795759
RUN apt-get update && apt-get install -yq libgconf-2-4

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN apt-get update && apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge --auto-remove -y curl \
    && rm -rf /src/*.deb

# Uncomment to skip the chromium download when installing puppeteer. If you do,
# you'll need to launch puppeteer with:
#     browser.launch({executablePath: 'google-chrome-unstable'})
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Tell @cloudcannon/suite to use google-chrome-unstable
ENV DOCKER_SCREENSHOTS true

# Install puppeteer so it's available in the container.
RUN npm i puppeteer

RUN mkdir /home/circleci/project

RUN chown -R circleci:circleci /home/circleci

USER circleci

WORKDIR /home/circleci/
