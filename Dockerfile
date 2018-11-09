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

# Install requirements for puppeteer
RUN \
  apt-get update && \
  apt-get install -yq gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
  libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
  libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
  libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
  ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget && \
  rm -rf /var/lib/apt/lists/*

# Install puppeteer so it's available in the container.
RUN yarn add puppeteer

USER circleci
