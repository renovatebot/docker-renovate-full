ARG RENOVATE_VERSION

# update trigger
FROM renovate/renovate:23.25.1-slim@sha256:ae632dc31aa87690efdb76c5a5859d7dee23614e9f294857a2cc53382db131dc

FROM renovate/renovate:${RENOVATE_VERSION}-slim

# The following resets the slim base images's binarySource=docker setting back to default
ENV RENOVATE_BINARY_SOURCE=

USER root

# renovate: datasource=docker lookupName=openjdk versioning=docker
RUN install-tool java 11

# renovate: datasource=gradle-version versioning=maven
RUN install-tool gradle 6.6.1

RUN install-tool erlang 22.0.2-1

# renovate: datasource=docker versioning=docker
RUN install-tool elixir 1.10.4

# renovate: datasource=docker versioning=docker
RUN install-tool php 7.4

# renovate: datasource=github-releases lookupName=composer/composer
RUN install-tool composer 1.10.13

# renovate: datasource=docker versioning=docker
RUN install-tool golang 1.15.2

# renovate: datasource=github-tags lookupName=renovatebot/python
RUN install-tool python 3.8.5

# renovate: datasource=pypi
RUN install-tool pip 20.2.3

# renovate: datasource=pypi
RUN install-pip pipenv 2020.8.13

# renovate: datasource=github-releases lookupName=python-poetry/poetry
RUN install-tool poetry 1.0.10

# renovate: datasource=pypi
RUN install-pip hashin 0.15.0

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.46.0

# renovate: datasource=docker versioning=docker
RUN install-tool ruby 2.7.1

# renovate: datasource=rubygems versioning=ruby
RUN install-gem cocoapods 1.9.3

# renovate: datasource=npm versioning=npm
RUN install-tool pnpm 5.5.13

RUN npm install -g lerna

USER 1000
