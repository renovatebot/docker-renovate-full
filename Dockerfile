FROM renovate/renovate:19.239.9-slim@sha256:a2719913c79c74c9127bdb651b3c2ad220cdd549c3f63a489b647b2dcd073b0e

# The following resets the slim base images's binarySource=docker setting back to default
ENV RENOVATE_BINARY_SOURCE=

USER root

# renovate: datasource=docker lookupName=openjdk versioning=docker
RUN install-tool java 8

# renovate: datasource=gradle-version versioning=maven
RUN install-tool gradle 6.3

RUN install-tool erlang 22.0.2-1

# renovate: datasource=docker versioning=docker
RUN install-tool elixir 1.8.2

# renovate: datasource=docker versioning=docker
RUN install-tool php 7.4

# renovate: datasource=github-releases lookupName=composer/composer
RUN install-tool composer 1.10.6

# renovate: datasource=docker versioning=docker
RUN install-tool golang 1.14.3

# renovate: datasource=docker
RUN install-tool python 3.8.3

# renovate: datasource=pypi
RUN install-tool pip 20.0.2

# renovate: datasource=pypi
RUN install-pip pipenv 2018.11.26

# renovate: datasource=github-releases lookupName=python-poetry/poetry
RUN install-tool poetry 1.0.5

# renovate: datasource=docker versioning=docker
RUN install-tool rust 1.36.0

# renovate: datasource=docker versioning=docker
RUN install-tool ruby 2.5.8

# renovate: datasource=rubygems versioning=ruby
RUN install-gem cocoapods 1.9.1

# renovate: datasource=npm versioning=npm
RUN install-tool pnpm 4.12.5

USER 1000
