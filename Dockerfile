# renovate: datasource=docker depName=renovate/renovate
ARG RENOVATE_VERSION=24.116.2

FROM renovate/renovate:${RENOVATE_VERSION}-slim as distsource

# Base image
#============
FROM renovate/buildpack:5@sha256:7d82f011ac21f564778ff9a213a641a9dd8d9a16e5c9dbaf9a4379487bdc8c12

LABEL name="renovate"
LABEL org.opencontainers.image.source="https://github.com/renovatebot/renovate" \
  org.opencontainers.image.url="https://renovatebot.com" \
  org.opencontainers.image.licenses="AGPL-3.0-only"

# renovate: datasource=docker versioning=docker
RUN install-tool node 14.16.1

# renovate: datasource=npm versioning=npm
RUN install-tool yarn 1.22.10

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
RUN install-tool composer 2.0.12

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

WORKDIR /usr/src/app

COPY --from=distsource /usr/src/app/package.json usr/src/app/package.json
COPY --from=distsource /usr/src/app/dist /usr/src/app/dist

# TODO: remove
COPY --from=distsource /usr/src/app/node_modules /usr/src/app/node_modules

COPY --from=distsource /usr/local/bin/docker-entrypoint.sh /usr/local/bin/

RUN ln -sf /usr/src/app/dist/renovate.js /usr/local/bin/renovate;
RUN ln -sf /usr/src/app/dist/config-validator.js /usr/local/bin/renovate-config-validator;
CMD ["renovate"]

RUN npm --no-git-tag-version version ${RENOVATE_VERSION} && renovate --version;

LABEL org.opencontainers.image.version="${RENOVATE_VERSION}"

# Numeric user ID for the ubuntu user. Used to indicate a non-root user to OpenShift
USER 1000
