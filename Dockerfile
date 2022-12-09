# renovate: datasource=npm depName=renovate versioning=npm
ARG RENOVATE_VERSION=34.53.0

# Base image
#============
FROM ghcr.io/containerbase/buildpack:5.2.3@sha256:dfdd081f2063c79a4adfbac342857b6f2d5637d7a2249bed4e48997437c02aa1 AS base

LABEL name="renovate"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/renovate" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="AGPL-3.0-only"

# renovate: datasource=node
RUN install-tool node v16.18.1

# renovate: datasource=npm versioning=npm
RUN install-tool yarn 1.22.19

WORKDIR /usr/src/app

# Build image
#============
FROM base as tsbuild

COPY . .

RUN set -ex; \
  yarn install; \
  yarn build; \
  chmod +x dist/*.js;

# hardcode node version to renovate
RUN set -ex; \
  NODE_VERSION=$(node -v | cut -c2-); \
  sed -i "1 s:.*:#\!\/opt\/buildpack\/tools\/node\/${NODE_VERSION}\/bin\/node:" "dist/renovate.js"; \
  sed -i "1 s:.*:#\!\/opt\/buildpack\/tools\/node\/${NODE_VERSION}\/bin\/node:" "dist/config-validator.js";

ARG RENOVATE_VERSION
RUN set -ex; \
  yarn version --new-version ${RENOVATE_VERSION}; \
  yarn add -E  renovate@${RENOVATE_VERSION} --production;  \
  node -e "new require('re2')('.*').exec('test')";


# Final image
#============
FROM base as final

# renovate: datasource=docker versioning=docker
RUN install-tool docker 20.10.21

# renovate: datasource=adoptium-java
RUN install-tool java 17.0.5+8

# renovate: datasource=gradle-version versioning=gradle
RUN install-tool gradle 7.6

# renovate: datasource=github-releases lookupName=containerbase/erlang-prebuild versioning=docker
RUN install-tool erlang 25.1.2.0

# renovate: datasource=docker versioning=docker
RUN install-tool elixir 1.14.2

# renovate: datasource=github-releases lookupName=containerbase/php-prebuild
RUN install-tool php 8.1.13

# renovate: datasource=github-releases lookupName=composer/composer
RUN install-tool composer 2.4.4

# renovate: datasource=golang-version
RUN install-tool golang 1.19.4

# renovate: datasource=github-releases lookupName=containerbase/python-prebuild
RUN install-tool python 3.11.1

# renovate: datasource=pypi
RUN install-pip pipenv 2022.11.30

# renovate: datasource=github-releases lookupName=python-poetry/poetry
RUN install-tool poetry 1.2.2

# renovate: datasource=pypi
RUN install-pip hashin 0.17.0

# renovate: datasource=pypi
RUN install-pip pip-tools 6.11.0

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.65.0

# renovate: datasource=github-releases lookupName=containerbase/ruby-prebuild
RUN install-tool ruby 3.1.3

# renovate: datasource=rubygems versioning=ruby
RUN install-gem bundler 2.3.26

# renovate: datasource=rubygems versioning=ruby
RUN install-gem cocoapods 1.11.3

# renovate: datasource=docker lookupName=mcr.microsoft.com/dotnet/sdk
RUN install-tool dotnet 6.0.403

# renovate: datasource=npm versioning=npm
RUN install-tool pnpm 7.17.1

# renovate: datasource=npm versioning=npm
RUN install-npm lerna 6.1.0

# renovate: datasource=github-releases lookupName=helm/helm
RUN install-tool helm v3.10.2

# renovate: datasource=github-releases lookupName=jsonnet-bundler/jsonnet-bundler
RUN install-tool jb v0.5.1

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
