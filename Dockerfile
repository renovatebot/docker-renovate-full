ARG RENOVATE_VERSION

# update trigger
FROM renovate/renovate:22.8.1-slim@sha256:ebc711413dc983419dcbdbd320078c0c1a0f0b2e0a98be7c9c203d9c29e369e2

FROM renovate/renovate:${RENOVATE_VERSION}-slim

# The following resets the slim base images's binarySource=docker setting back to default
ENV RENOVATE_BINARY_SOURCE=

USER root

# renovate: datasource=docker lookupName=openjdk versioning=docker
RUN install-tool java 11

# renovate: datasource=gradle-version versioning=maven
RUN install-tool gradle 6.5.1

RUN install-tool erlang 22.0.2-1

# renovate: datasource=docker versioning=docker
RUN install-tool elixir 1.10.4

# renovate: datasource=docker versioning=docker
RUN install-tool php 7.4

# renovate: datasource=github-releases lookupName=composer/composer
RUN install-tool composer 1.10.10

# renovate: datasource=docker versioning=docker
RUN install-tool golang 1.14.6

# renovate: datasource=github-tags lookupName=renovatebot/python
RUN install-tool python 3.8.5

# renovate: datasource=pypi
RUN install-tool pip 20.1.1

# renovate: datasource=pypi
RUN install-pip pipenv 2020.6.2

# renovate: datasource=github-releases lookupName=python-poetry/poetry
RUN install-tool poetry 1.0.10

# renovate: datasource=pypi
RUN install-pip hashin 0.15.0

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.45.2

# renovate: datasource=docker versioning=docker
RUN install-tool ruby 2.7.1

# renovate: datasource=rubygems versioning=ruby
RUN install-gem cocoapods 1.9.3

# renovate: datasource=npm versioning=npm
RUN install-tool pnpm 5.4.11

RUN npm install -g lerna

USER 1000
