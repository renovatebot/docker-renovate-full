# renovate: datasource=npm depName=renovate versioning=npm
ARG RENOVATE_VERSION=25.22.0

# Base image
#============
FROM renovate/buildpack:5@sha256:4475102266c3a7ce983f959edd2b392ded0b4b6e0b902780304a3ab0056e88c7 AS base

LABEL name="renovate"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/renovate" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="AGPL-3.0-only"

# renovate: datasource=docker versioning=docker
RUN install-tool node 14.17.0

# renovate: datasource=npm versioning=npm
RUN install-tool yarn 1.22.10

WORKDIR /usr/src/app

# Build image
#============
FROM base as tsbuild

COPY . .

RUN set -ex; \
  yarn install; \
  yarn build; \
  chmod +x dist/*.js;

ARG RENOVATE_VERSION
RUN set -ex; \
  yarn version --new-version ${RENOVATE_VERSION}; \
  yarn add -E  renovate@${RENOVATE_VERSION} --production;  \
  node -e "new require('re2')('.*').exec('test')";


# Final image
#============
FROM base as final

# renovate: datasource=docker versioning=docker
RUN install-tool docker 20.10.6

# renovate: datasource=docker lookupName=openjdk versioning=docker
RUN install-tool java 11

# renovate: datasource=gradle-version versioning=maven
RUN install-tool gradle 6.9

RUN install-tool erlang 22.3.2

# renovate: datasource=docker versioning=docker
RUN install-tool elixir 1.11.4

# renovate: datasource=github-releases lookupName=containerbase/php-prebuild
RUN install-tool php 7.4.19

# renovate: datasource=github-releases lookupName=composer/composer
RUN install-tool composer 2.0.13

# renovate: datasource=docker versioning=docker
RUN install-tool golang 1.16.4

# renovate: datasource=github-releases lookupName=renovatebot/python
RUN install-tool python 3.9.3

# renovate: datasource=pypi
RUN install-pip pipenv 2020.11.15

# renovate: datasource=github-releases lookupName=python-poetry/poetry
RUN install-tool poetry 1.1.6

# renovate: datasource=pypi
RUN install-pip hashin 0.15.0

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.52.1

# renovate: datasource=github-releases lookupName=renovatebot/ruby
RUN install-tool ruby 3.0.0

# renovate: datasource=rubygems versioning=ruby
RUN install-gem cocoapods 1.10.1

# renovate: datasource=npm versioning=npm
RUN install-tool pnpm 5.18.9

# renovate: datasource=docker lookupName=mcr.microsoft.com/dotnet/sdk
RUN install-tool dotnet 3.1.409

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


RUN set -ex; \
  renovate --version; \
  renovate-config-validator; \
  node -e "new require('re2')('.*').exec('test')";

ARG RENOVATE_VERSION
LABEL org.opencontainers.image.version="${RENOVATE_VERSION}"

# Numeric user ID for the ubuntu user. Used to indicate a non-root user to OpenShift
USER 1000
