# renovate: datasource=npm depName=renovate versioning=npm
ARG RENOVATE_VERSION=26.1.2

# Base image
#============
FROM renovate/buildpack:5@sha256:25fe3aa1c00be3b1d857ec110845b2b2bb2e8031c4412f244ff5735f3c943bb7 AS base

LABEL name="renovate"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/renovate" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="AGPL-3.0-only"

# renovate: datasource=npm depName=node versioning=node
RUN install-tool node 14.17.0

# renovate: datasource=npm versioning=npm
RUN install-tool yarn 1.22.11

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
RUN install-tool docker 20.10.8

# renovate: datasource=docker lookupName=openjdk versioning=docker
RUN install-tool java 11

# renovate: datasource=gradle-version versioning=maven
RUN install-tool gradle 6.9

RUN install-tool erlang 22.3.2

# renovate: datasource=docker versioning=docker
RUN install-tool elixir 1.12.2

# renovate: datasource=github-releases lookupName=containerbase/php-prebuild
RUN install-tool php 7.4.22

# renovate: datasource=github-releases lookupName=composer/composer
RUN install-tool composer 2.1.5

# renovate: datasource=docker versioning=docker
RUN install-tool golang 1.17.0

# renovate: datasource=github-releases lookupName=containerbase/python-prebuild
RUN install-tool python 3.9.6

# renovate: datasource=pypi
RUN install-pip pipenv 2020.11.15

# renovate: datasource=github-releases lookupName=python-poetry/poetry
RUN install-tool poetry 1.1.7

# renovate: datasource=pypi
RUN install-pip hashin 0.15.0

# renovate: datasource=pypi
RUN install-pip pip-tools 6.2.0

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.54.0

# renovate: datasource=github-releases lookupName=containerbase/ruby-prebuild
RUN install-tool ruby 3.0.2

# renovate: datasource=rubygems versioning=ruby
RUN install-gem cocoapods 1.10.2

# renovate: datasource=docker lookupName=mcr.microsoft.com/dotnet/sdk
RUN install-tool dotnet 3.1.412

# renovate: datasource=npm versioning=npm
RUN install-tool pnpm 6.12.1

# renovate: datasource=npm versioning=npm
RUN install-npm lerna 4.0.0

# renovate: datasource=github-releases lookupName=helm/helm
RUN install-tool helm v3.6.3

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
