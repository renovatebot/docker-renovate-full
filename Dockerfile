# renovate: datasource=npm depName=renovate versioning=npm
ARG RENOVATE_VERSION=25.7.6

# Base image
#============
FROM renovate/buildpack:5@sha256:c08da7660715a53d15c18d0ebb62f13eb5b2d0204610f17163e8efb193c91f65 AS base

LABEL name="renovate"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/renovate" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="AGPL-3.0-only"

# renovate: datasource=docker versioning=docker
RUN install-tool node 14.16.1

# renovate: datasource=npm versioning=npm
RUN install-tool yarn 1.22.10

WORKDIR /usr/src/app

# Build image
#============
FROM base as tsbuild

# use buildin python to faster build
RUN install-apt build-essential python3
RUN npm install -g yarn-deduplicate

COPY package.json .
COPY yarn.lock .

RUN yarn install --frozen-lockfile

COPY tsconfig.json .
COPY tsconfig.app.json .
COPY src src

RUN set -ex; \
  yarn build; \
  chmod +x dist/*.js;

ARG RENOVATE_VERSION
RUN npm --no-git-tag-version version ${RENOVATE_VERSION}
RUN yarn add renovate@${RENOVATE_VERSION}
RUN yarn-deduplicate --strategy highest
RUN yarn install --frozen-lockfile --production

# check is re2 is usable
RUN node -e "new require('re2')('.*').exec('test')"


# Final image
#============
FROM base as final

# renovate: datasource=docker versioning=docker
RUN install-tool docker 20.10.6

# renovate: datasource=docker lookupName=openjdk versioning=docker
RUN install-tool java 11

# renovate: datasource=gradle-version versioning=maven
RUN install-tool gradle 6.8.3

RUN install-tool erlang 22.3.2

# renovate: datasource=docker versioning=docker
RUN install-tool elixir 1.11.4

# renovate: datasource=github-releases lookupName=containerbase/php-prebuild
RUN install-tool php 7.4.16

# renovate: datasource=github-releases lookupName=composer/composer
RUN install-tool composer 2.0.13

# renovate: datasource=docker versioning=docker
RUN install-tool golang 1.16.3

# renovate: datasource=github-releases lookupName=renovatebot/python
RUN install-tool python 3.9.3

# renovate: datasource=pypi
RUN install-pip pipenv 2020.11.15

# renovate: datasource=github-releases lookupName=python-poetry/poetry
RUN install-tool poetry 1.1.6

# renovate: datasource=pypi
RUN install-pip hashin 0.15.0

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.51.0

# renovate: datasource=github-releases lookupName=renovatebot/ruby
RUN install-tool ruby 3.0.0

# renovate: datasource=rubygems versioning=ruby
RUN install-gem cocoapods 1.10.1

# renovate: datasource=npm versioning=npm
RUN install-tool pnpm 5.18.9

# renovate: datasource=docker lookupName=mcr.microsoft.com/dotnet/sdk
RUN install-tool dotnet 3.1.408

RUN npm install -g lerna

# renovate: datasource=github-releases lookupName=helm/helm
RUN install-tool helm v3.5.4

COPY --from=tsbuild /usr/src/app/package.json package.json
COPY --from=tsbuild /usr/src/app/dist dist
COPY --from=tsbuild /usr/src/app/node_modules node_modules

# exec helper
COPY bin/ /usr/local/bin/
RUN ln -sf /usr/src/app/dist/renovate.js /usr/local/bin/renovate;
RUN ln -sf /usr/src/app/dist/config-validator.js /usr/local/bin/renovate-config-validator;
CMD ["renovate"]

ARG RENOVATE_VERSION

RUN renovate --version;

LABEL org.opencontainers.image.version="${RENOVATE_VERSION}"

# Numeric user ID for the ubuntu user. Used to indicate a non-root user to OpenShift
USER 1000
