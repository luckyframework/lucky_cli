FROM crystallang/crystal:latest AS base
WORKDIR /app

RUN apt-get update \
     && apt-get install -y postgresql-client ca-certificates curl gnupg libnss3 libnss3-dev wget \
     && mkdir -p /etc/apt/keyrings \
     && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
     && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
     && apt-get update \
     && apt-get install -y nodejs \
     && npm install --global yarn \
     && wget -O /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
     && apt-get install -y /tmp/google-chrome-stable_current_amd64.deb

ENV CHROME_BIN=/usr/bin/google-chrome
ENV SHARDS_OVERRIDE=$(pwd)/shard.override.yml

COPY shard.yml shard.lock ./
RUN shards install --production

COPY . .

FROM base AS build
RUN shards build lucky --without-development


FROM build AS e2e_full_web
RUN lucky init.custom test-project
WORKDIR /workdir/test-project
RUN crystal tool format --check src spec config
RUN yarn install --no-progress \
  && yarn dev \
  && shards install
RUN crystal build src/start_server.cr
RUN crystal build src/test_project.cr
RUN crystal run src/app.cr


FROM build AS e2e_web_noauth
RUN lucky init.custom test-project --no-auth
WORKDIR /workdir/test-project
RUN yarn install --no-progress \
  && yarn dev \
  && shards install
RUN lucky gen.action.api Api::Users::Show \
  && lucky gen.action.browser Users::Show \
  && lucky gen.migration CreateThings \
  && lucky gen.model User \
  && lucky gen.page Users::IndexPage \
  && lucky gen.component Users::Header \
  && lucky gen.resource.browser Comment title:String \
  && lucky gen.task email.monthly_update \
  && lucky gen.secret_key
RUN crystal tool format --check src spec config
RUN crystal build src/start_server.cr
RUN crystal build src/test_project.cr
RUN crystal run src/app.cr


FROM build AS e2e_full_api
RUN lucky init.custom test-project --api
WORKDIR /workdir/test-project
RUN crystal tool format --check src spec config
RUN shards install
RUN crystal build src/start_server.cr
RUN crystal build src/test_project.cr
RUN crystal run src/app.cr


FROM build AS e2e_api_noauth
RUN lucky init.custom test-project --api --no-auth
WORKDIR /workdir/test-project
RUN crystal tool format --check src spec config
RUN shards install
RUN crystal build src/start_server.cr
RUN crystal build src/test_project.cr
RUN crystal run src/app.cr


FROM build AS e2e_security
ARG github_ref
ARG github_sha
ARG github_run_id
RUN lucky init.custom test-project --with-sec-test
WORKDIR /workdir/test-project
RUN crystal tool format --check src spec config
RUN yarn install --no-progress \
  && yarn dev \
  && shards install
ENV LUCKY_ENV=test
ENV RUN_SEC_TESTER_SPECS=1
ENV GITHUB_REF=$github_ref
ENV GITHUB_SHA=$github_sha
ENV GITHUB_RUN_ID=$github_run_id
