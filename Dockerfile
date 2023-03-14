# renovate: datasource=npm depName=renovate versioning=npm
ARG RENOVATE_VERSION=35.4.1

# Base image
#============
FROM ghcr.io/containerbase/buildpack:6.4.0@sha256:2d3a47f481b3ee882519506e580483410c5e18f5c68d16081f86c7b65f47a0a9 AS base

LABEL name="renovate"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/renovate" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="AGPL-3.0-only"

# prepare all tools
RUN prepare-tool all

# renovate: datasource=node
RUN install-tool node v18.15.0

# renovate: datasource=npm versioning=npm
RUN install-tool npm 9.6.1

# renovate: datasource=npm versioning=npm
RUN install-tool yarn 1.22.19

WORKDIR /usr/src/app

# renovate: datasource=docker versioning=docker
RUN install-tool docker 23.0.1

# renovate: datasource=adoptium-java
RUN install-tool java 17.0.6+10

# renovate: datasource=gradle-version versioning=gradle
RUN install-tool gradle 8.0.2

# renovate: datasource=github-releases lookupName=containerbase/erlang-prebuild versioning=docker
RUN install-tool erlang 25.3.0.0

# renovate: datasource=docker versioning=docker
RUN install-tool elixir 1.14.3

# renovate: datasource=github-releases lookupName=containerbase/php-prebuild
RUN install-tool php 8.2.3

# renovate: datasource=github-releases lookupName=composer/composer
RUN install-tool composer 2.5.4

# renovate: datasource=golang-version
RUN install-tool golang 1.20.2

# renovate: datasource=github-releases lookupName=containerbase/python-prebuild
RUN install-tool python 3.11.2

# renovate: datasource=pypi
RUN install-pip pipenv 2023.2.18

# renovate: datasource=github-releases lookupName=python-poetry/poetry
RUN install-tool poetry 1.4.0

# renovate: datasource=pypi
RUN install-pip hashin 0.17.0

# renovate: datasource=pypi
RUN install-pip pip-tools 6.12.3

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.68.0

# renovate: datasource=github-releases lookupName=containerbase/ruby-prebuild
RUN install-tool ruby 3.2.1

# renovate: datasource=rubygems versioning=ruby
RUN install-tool bundler 2.4.8

# renovate: datasource=rubygems versioning=ruby
RUN install-tool cocoapods 1.12.0

# renovate: datasource=docker lookupName=mcr.microsoft.com/dotnet/sdk
RUN install-tool dotnet 7.0.201

# renovate: datasource=npm versioning=npm
RUN install-tool pnpm 7.29.1

# renovate: datasource=npm versioning=npm
RUN install-npm lerna 6.5.1

# renovate: datasource=github-releases lookupName=helm/helm
RUN install-tool helm v3.11.2

# renovate: datasource=github-releases lookupName=jsonnet-bundler/jsonnet-bundler
RUN install-tool jb v0.5.1

ENV RENOVATE_X_IGNORE_NODE_WARN=true

# exec helper
COPY bin/ /usr/local/bin/
CMD ["renovate"]

ARG RENOVATE_VERSION

RUN install-tool renovate

# Compabillity, so `config.js` can access renovate and deps
RUN ln -sf /opt/buildpack/tools/renovate/${RENOVATE_VERSION}/node_modules ./node_modules;

RUN set -ex; \
  renovate --version; \
  renovate-config-validator; \
  node -e "new require('re2')('.*').exec('test')"; \
  true

LABEL org.opencontainers.image.version="${RENOVATE_VERSION}"

# Numeric user ID for the ubuntu user. Used to indicate a non-root user to OpenShift
USER 1000
