ARG RENOVATE_VERSION

# update trigger
FROM renovate/renovate:20.16.1-slim@sha256:34a225ba09b85f8f8a6d2f75fbb8392dd058e0656ba5b78bca8d5170e1a9f4e0

FROM renovate/renovate:${RENOVATE_VERSION}-slim

# The following resets the slim base images's binarySource=docker setting back to default
ENV RENOVATE_BINARY_SOURCE=

USER root

# renovate: datasource=docker lookupName=openjdk versioning=docker
RUN install-tool java 11

# renovate: datasource=gradle-version versioning=maven
RUN install-tool gradle 6.4.1

RUN install-tool erlang 22.0.2-1

# renovate: datasource=docker versioning=docker
RUN install-tool elixir 1.10.3

# renovate: datasource=docker versioning=docker
RUN install-tool php 7.4

# renovate: datasource=github-releases lookupName=composer/composer
RUN install-tool composer 1.10.6

# renovate: datasource=docker versioning=docker
RUN install-tool golang 1.14.3

# renovate: datasource=docker
RUN install-tool python 3.8.3

# renovate: datasource=pypi
RUN install-tool pip 20.1.1

# renovate: datasource=pypi
RUN install-pip pipenv 2018.11.26

# renovate: datasource=github-releases lookupName=python-poetry/poetry
RUN install-tool poetry 1.0.5

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.43.1

# renovate: datasource=docker versioning=docker
RUN install-tool ruby 2.7.1

# renovate: datasource=rubygems versioning=ruby
RUN install-gem cocoapods 1.9.3

# renovate: datasource=npm versioning=npm
RUN install-tool pnpm 4.14.4

USER 1000
