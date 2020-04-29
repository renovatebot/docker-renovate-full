# renovate: datasource=npm depName=renovate versioning=npm
ARG RENOVATE_VERSION=19.221.4

# dummy for rebuilding
FROM renovate/renovate:19.222.0-slim@sha256:187eead75407faac8780f32e97dd2ebce1e5d5d7aab76ee0a48bdc1beab84e89

FROM renovate/renovate:$RENOVATE_VERSION-slim

ENV RENOVATE_BINARY_SOURCE=

USER root

# go suggests: git svn bzr mercurial
RUN install-apt bzr mercurial

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
RUN install-tool composer 1.10.5

# renovate: datasource=docker versioning=docker
RUN install-tool golang 1.14.2

# renovate: datasource=docker
RUN install-tool python 3.8.2

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
