ARG RENOVATE_VERSION

# update trigger
FROM renovate/renovate:21.12.2-slim@sha256:264244ad6f0ff1c5a5be61a2bc9cc9fe105435974977f4e44ac84b3651bf3295

FROM renovate/renovate:${RENOVATE_VERSION}-slim

# The following resets the slim base images's binarySource=docker setting back to default
ENV RENOVATE_BINARY_SOURCE=

USER root

# renovate: datasource=docker lookupName=openjdk versioning=docker
RUN install-tool java 11

# renovate: datasource=gradle-version versioning=maven
RUN install-tool gradle 6.5

RUN install-tool erlang 22.0.2-1

# renovate: datasource=docker versioning=docker
RUN install-tool elixir 1.10.3

# renovate: datasource=docker versioning=docker
RUN install-tool php 7.4

# renovate: datasource=github-releases lookupName=composer/composer
RUN install-tool composer 1.10.7

# renovate: datasource=docker versioning=docker
RUN install-tool golang 1.14.4

# renovate: datasource=docker
RUN install-tool python 3.8.3

# renovate: datasource=pypi
RUN install-tool pip 20.1.1

# renovate: datasource=pypi
RUN install-pip pipenv 2020.6.2

# renovate: datasource=github-releases lookupName=python-poetry/poetry
RUN install-tool poetry 1.0.9

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.44.0

# renovate: datasource=docker versioning=docker
RUN install-tool ruby 2.7.1

# renovate: datasource=rubygems versioning=ruby
RUN install-gem cocoapods 1.9.3

# renovate: datasource=npm versioning=npm
RUN install-tool pnpm 5.2.1

RUN npm install -g lerna

USER 1000
