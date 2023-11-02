# renovate: datasource=npm depName=renovate versioning=npm
ARG RENOVATE_VERSION=37.43.1

# Base image
#============
FROM ghcr.io/containerbase/base:9.23.10@sha256:500fe665605b6bcad30014bff345c56c6bdb1c148ae79d4ac56f84a9c046edfd AS base

LABEL name="renovate"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/renovate" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="AGPL-3.0-only"

# prepare all tools
RUN prepare-tool all

# renovate: datasource=node
RUN install-tool node v18.18.2

# renovate: datasource=npm versioning=npm
RUN install-tool npm 10.2.1

# renovate: datasource=npm versioning=npm
RUN install-tool yarn 1.22.19

WORKDIR /usr/src/app

# renovate: datasource=github-releases packageName=moby/moby
RUN install-tool docker v24.0.7

# renovate: datasource=adoptium-java
RUN install-tool java 17.0.9+9

# renovate: datasource=gradle-version versioning=gradle
RUN install-tool gradle 8.4

# renovate: datasource=github-releases lookupName=containerbase/erlang-prebuild versioning=docker
RUN install-tool erlang 26.1.2.0

# renovate: datasource=docker versioning=docker
RUN install-tool elixir 1.15.6

# renovate: datasource=github-releases lookupName=containerbase/php-prebuild
RUN install-tool php 8.2.12

# renovate: datasource=github-releases lookupName=composer/composer
RUN install-tool composer 2.6.5

# renovate: datasource=golang-version
RUN install-tool golang 1.21.3

# renovate: datasource=github-releases lookupName=containerbase/python-prebuild
RUN install-tool python 3.11.5

# renovate: datasource=pypi
RUN install-tool pipenv 2023.10.24

# renovate: datasource=github-releases lookupName=python-poetry/poetry
RUN install-tool poetry 1.6.1

# renovate: datasource=pypi
RUN install-tool hashin 0.17.0

# renovate: datasource=pypi
RUN install-tool pip-tools 7.3.0

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.73.0

# renovate: datasource=github-releases lookupName=containerbase/ruby-prebuild
RUN install-tool ruby 3.2.2

# renovate: datasource=rubygems versioning=ruby
RUN install-tool bundler 2.4.21

# renovate: datasource=rubygems versioning=ruby
RUN install-tool cocoapods 1.14.1

# renovate: datasource=docker lookupName=mcr.microsoft.com/dotnet/sdk
RUN install-tool dotnet 7.0.403

# renovate: datasource=npm versioning=npm
RUN install-tool pnpm 8.9.2

# renovate: datasource=npm versioning=npm
RUN install-tool lerna 7.4.1

# renovate: datasource=github-releases lookupName=helm/helm
RUN install-tool helm v3.13.1

# renovate: datasource=github-releases lookupName=jsonnet-bundler/jsonnet-bundler
RUN install-tool jb v0.5.1

# renovate: datasource=github-tags packageName=NixOS/nix
RUN install-tool nix 2.18.1

ENV RENOVATE_X_IGNORE_NODE_WARN=true
ENV RENOVATE_BINARY_SOURCE=global

# exec helper
COPY bin/ /usr/local/bin/
CMD ["renovate"]

ARG RENOVATE_VERSION

RUN install-tool renovate

# Compabillity, so `config.js` can access renovate and deps
RUN ln -sf /opt/containerbase/tools/renovate/${RENOVATE_VERSION}/node_modules ./node_modules;

RUN set -ex; \
  renovate --version; \
  renovate-config-validator; \
  node -e "new require('re2')('.*').exec('test')"; \
  true

LABEL org.opencontainers.image.version="${RENOVATE_VERSION}"

# Numeric user ID for the ubuntu user. Used to indicate a non-root user to OpenShift
USER 1000
