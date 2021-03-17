# renovate: datasource=docker depName=renovate/renovate
ARG RENOVATE_VERSION=24.89.1

FROM renovate/renovate:${RENOVATE_VERSION}-slim

# The following resets the slim base images's binarySource=docker setting back to default
ENV RENOVATE_BINARY_SOURCE=

USER root

# renovate: datasource=docker lookupName=openjdk versioning=docker
RUN install-tool java 11

# renovate: datasource=gradle-version versioning=maven
RUN install-tool gradle 6.8.3

RUN install-tool erlang 22.3.2

# renovate: datasource=docker versioning=docker
RUN install-tool elixir 1.11.4

# renovate: datasource=docker versioning=docker
RUN install-tool php 7.4

# renovate: datasource=github-releases lookupName=composer/composer
RUN install-tool composer 2.0.11

# renovate: datasource=docker versioning=docker
RUN install-tool golang 1.16.2

# renovate: datasource=github-releases lookupName=renovatebot/python
RUN install-tool python 3.9.2

# renovate: datasource=pypi
RUN install-pip pipenv 2020.11.15

# renovate: datasource=github-releases lookupName=python-poetry/poetry
RUN install-tool poetry 1.1.5

# renovate: datasource=pypi
RUN install-pip hashin 0.15.0

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.50.0

# renovate: datasource=github-releases lookupName=renovatebot/ruby
RUN install-tool ruby 3.0.0

# renovate: datasource=rubygems versioning=ruby
RUN install-gem cocoapods 1.10.1

# renovate: datasource=npm versioning=npm
RUN install-tool pnpm 5.18.1

# renovate: datasource=docker lookupName=mcr.microsoft.com/dotnet/sdk
RUN install-tool dotnet 3.1.407

RUN npm install -g lerna

# renovate: datasource=github-releases lookupName=helm/helm
RUN install-tool helm v3.5.3

USER 1000
