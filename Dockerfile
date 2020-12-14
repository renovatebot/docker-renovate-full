ARG RENOVATE_VERSION

# update trigger
FROM renovate/renovate:23.100.5-slim@sha256:d777ded8316deedb864c3187fa346eebfa9349c15dc1a7370a7706c4b9f337f7

FROM renovate/renovate:${RENOVATE_VERSION}-slim

# The following resets the slim base images's binarySource=docker setting back to default
ENV RENOVATE_BINARY_SOURCE=

USER root

# renovate: datasource=docker lookupName=openjdk versioning=docker
RUN install-tool java 11

# renovate: datasource=gradle-version versioning=maven
RUN install-tool gradle 6.7.1

RUN install-tool erlang 22.0.2-1

# renovate: datasource=docker versioning=docker
RUN install-tool elixir 1.11.2

# renovate: datasource=docker versioning=docker
RUN install-tool php 7.4

# renovate: datasource=github-releases lookupName=composer/composer
RUN install-tool composer 2.0.8

# renovate: datasource=docker versioning=docker
RUN install-tool golang 1.15.6

# renovate: datasource=github-tags lookupName=renovatebot/python
RUN install-tool python 3.9.0

# renovate: datasource=pypi
RUN install-tool pip 20.3.1

# renovate: datasource=pypi
RUN install-pip pipenv 2020.11.15

# renovate: datasource=github-releases lookupName=python-poetry/poetry
RUN install-tool poetry 1.1.4

# renovate: datasource=pypi
RUN install-pip hashin 0.15.0

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.48.0

# renovate: datasource=docker versioning=docker
RUN install-tool ruby 2.7.2

# renovate: datasource=rubygems versioning=ruby
RUN install-gem cocoapods 1.10.0

# renovate: datasource=npm versioning=npm
RUN install-tool pnpm 5.13.5

# renovate: datasource=docker lookupName=mcr.microsoft.com/dotnet/sdk
RUN install-tool dotnet 3.1.404

RUN npm install -g lerna

# renovate: datasource=github-releases lookupName=helm/helm
RUN install-tool helm 3.4.1

USER 1000
