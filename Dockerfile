ARG RENOVATE_VERSION

# update trigger
FROM renovate/renovate:23.49.0-slim@sha256:16839674280b5d6b6396525e8bd3d1a0d8943367d5ab7cfa995aa494212e163d

FROM renovate/renovate:${RENOVATE_VERSION}-slim

# The following resets the slim base images's binarySource=docker setting back to default
ENV RENOVATE_BINARY_SOURCE=

USER root

# renovate: datasource=docker lookupName=openjdk versioning=docker
RUN install-tool java 11

# renovate: datasource=gradle-version versioning=maven
RUN install-tool gradle 6.7

RUN install-tool erlang 22.0.2-1

# renovate: datasource=docker versioning=docker
RUN install-tool elixir 1.10.4

# renovate: datasource=docker versioning=docker
RUN install-tool php 7.4

# renovate: datasource=github-releases lookupName=composer/composer
RUN install-tool composer 1.10.15

# renovate: datasource=docker versioning=docker
RUN install-tool golang 1.15.2

# renovate: datasource=github-tags lookupName=renovatebot/python
RUN install-tool python 3.9.0

# renovate: datasource=pypi
RUN install-tool pip 20.2.3

# renovate: datasource=pypi
RUN install-pip pipenv 2020.8.13

# renovate: datasource=github-releases lookupName=python-poetry/poetry
RUN install-tool poetry 1.1.3

# renovate: datasource=pypi
RUN install-pip hashin 0.15.0

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.47.0

# renovate: datasource=docker versioning=docker
RUN install-tool ruby 2.7.2

# renovate: datasource=rubygems versioning=ruby
RUN install-gem cocoapods 1.9.3

# renovate: datasource=npm versioning=npm
RUN install-tool pnpm 5.9.0

RUN npm install -g lerna

USER 1000
