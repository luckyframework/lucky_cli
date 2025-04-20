VERSION 0.8
FROM 84codes/crystal:latest-ubuntu-24.04
WORKDIR /workdir

# gh-action-essential runs only the necessary recipes
gh-action-essential:
    BUILD +format-check
    BUILD +lint
    BUILD +specs

# gh-action-integration runs all integration specs
gh-action-integration:
    BUILD +integration-specs

# gh-action-e2e runs all end-to-end specs
gh-action-e2e:
    BUILD +e2e-full-web-app
    BUILD +e2e-full-web-app-noauth
    BUILD +e2e-full-web-app-api
    BUILD +e2e-full-web-app-api-noauth

# gh-action-e2e-security runs all security tests (requires secrets)
gh-action-e2e-security:
    BUILD +e2e-sec-tester

# gh-action-weekly runs all weekly tests
gh-action-weekly:
    BUILD +weekly-latest-full-web-app
    BUILD +weekly-nightly-full-web-app

# format-check checks the format of source files
format-check:
    FROM +base-image
    RUN crystal tool format --check src spec

# specs runs unit tests
specs:
    FROM +base-specs-image
    RUN crystal spec --tag "~integration"

# update-snapshot updates spec fixtures
update-snapshot:
    FROM +base-specs-image
    ARG spec
    ENV SPEC_UPDATE_SNAPSHOT=1
    RUN crystal spec --tag "~integration" $spec
    SAVE ARTIFACT ./fixtures AS LOCAL ./fixtures

# lint runs ameba code linter
lint:
    FROM ghcr.io/crystal-ameba/ameba:1.5.0
    COPY --dir src ./
    COPY --dir spec ./
    RUN ameba

# integration-specs runs integration tests
integration-specs:
    FROM +base-image
    COPY +build-lucky/lucky /usr/bin/lucky
    COPY fixtures/hello_world.cr fixtures/
    COPY fixtures/hello_crystal.cr bin/lucky.hello_crystal.cr
    COPY fixtures/tasks.cr fixtures/
    RUN shards build lucky.hello_world --without-development
    RUN crystal spec --tag integration

# e2e-full-web-app tests lucky full web app
e2e-full-web-app:
    FROM earthly/dind:alpine
    COPY docker-compose.yml ./
    WITH DOCKER \
        --compose docker-compose.yml \
        --load lucky-image:latest=+e2e-image
        RUN docker run --network=host lucky-image:latest
    END

# e2e-full-web-app-noauth tests lucky full web app with no auth
e2e-full-web-app-noauth:
    FROM earthly/dind:alpine
    COPY docker-compose.yml ./
    WITH DOCKER \
        --compose docker-compose.yml \
        --load lucky-image:latest=+e2e-image-noauth
        RUN docker run --network=host lucky-image:latest
    END

# e2e-full-web-app-api tests lucky full web app with api
e2e-full-web-app-api:
    FROM earthly/dind:alpine
    COPY docker-compose.yml ./
    WITH DOCKER \
        --compose docker-compose.yml \
        --load lucky-image:latest=+e2e-image-api
        RUN docker run --network=host lucky-image:latest
    END

# e2e-full-web-app-api-noauth tests lucky full web app with api and no auth
e2e-full-web-app-api-noauth:
    FROM earthly/dind:alpine
    COPY docker-compose.yml ./
    WITH DOCKER \
        --compose docker-compose.yml \
        --load lucky-image:latest=+e2e-image-api-noauth
        RUN docker run --network=host lucky-image:latest
    END

# e2e-sec-tester tests lucky full app with security tester enabled
e2e-sec-tester:
    FROM earthly/dind:alpine
    COPY docker-compose.yml ./
    WITH DOCKER \
        --compose docker-compose.yml \
        --load lucky-image:latest=+e2e-image-security
        RUN --secret BRIGHT_TOKEN --secret BRIGHT_PROJECT_ID -- \
            docker run \
                --network=host \
                -e BRIGHT_TOKEN \
                -e BRIGHT_PROJECT_ID \
                lucky-image:latest
    END

# weekly-latest-full-web-app tests lucky full web app (crystal: latest) for catching potential issues on newer versions of packages
weekly-latest-full-web-app:
    FROM earthly/dind:alpine
    COPY docker-compose.yml ./
    WITH DOCKER \
        --compose docker-compose.yml \
        --load lucky-image:latest=+weekly-latest-image
        RUN docker run --network=host lucky-image:latest
    END

# weekly-nightly-full-web-app tests lucky full web app (crystal: nightly) for more insight into upcoming crystal versions
weekly-nightly-full-web-app:
    FROM earthly/dind:alpine
    COPY docker-compose.yml ./
    WITH DOCKER \
        --compose docker-compose.yml \
        --load lucky-image:latest=+weekly-nightly-image
        RUN docker run --network=host lucky-image:latest
    END

# release-static builds an executable statically linked
release-static:
    FROM 84codes/crystal:latest-alpine
    WORKDIR /workdir
    COPY --dir src ./
    COPY shard.yml ./
    RUN apk add yaml-static
    RUN shards build lucky --without-development --no-debug --release --static
    SAVE ARTIFACT ./bin/lucky

build-lucky:
    WORKDIR /lucky_cli
    COPY --dir src ./
    COPY fixtures/hello_world.cr fixtures/
    COPY shard.yml ./
    RUN shards build lucky --without-development
    SAVE ARTIFACT ./bin/lucky

base-image:
    COPY --dir src ./
    COPY --dir spec ./
    COPY shard.yml ./

base-specs-image:
    FROM +base-image
    COPY --dir fixtures ./
    RUN shards install

e2e-base-image:
    COPY shard.override.yml ./
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
    COPY +build-lucky/lucky /usr/bin/lucky

e2e-image:
    FROM +e2e-base-image
    RUN lucky init.custom test-project
    WORKDIR /workdir/test-project
    RUN crystal tool format --check src spec config
    RUN yarn install --no-progress \
     && yarn dev \
     && shards install
    RUN crystal build src/start_server.cr
    RUN crystal build src/test_project.cr
    RUN crystal run src/app.cr
    ENTRYPOINT ["crystal", "spec"]
    SAVE IMAGE lucky-image:base

e2e-image-noauth:
    FROM +e2e-base-image
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
    ENTRYPOINT ["crystal", "spec"]
    SAVE IMAGE lucky-image:noauth

e2e-image-api:
    FROM +e2e-base-image
    RUN lucky init.custom test-project --api
    WORKDIR /workdir/test-project
    RUN crystal tool format --check src spec config
    RUN shards install
    RUN crystal build src/start_server.cr
    RUN crystal build src/test_project.cr
    RUN crystal run src/app.cr
    ENTRYPOINT ["crystal", "spec"]
    SAVE IMAGE lucky-image:api

e2e-image-api-noauth:
    FROM +e2e-base-image
    RUN lucky init.custom test-project --api --no-auth
    WORKDIR /workdir/test-project
    RUN crystal tool format --check src spec config
    RUN shards install
    RUN crystal build src/start_server.cr
    RUN crystal build src/test_project.cr
    RUN crystal run src/app.cr
    ENTRYPOINT ["crystal", "spec"]
    SAVE IMAGE lucky-image:api-noauth

e2e-image-security:
    FROM +e2e-base-image
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
    ENTRYPOINT ["crystal", "spec", "-Dwith_sec_tests"]
    SAVE IMAGE lucky-image:security

weekly-latest-image:
    FROM 84codes/crystal:latest-ubuntu-22.04
    DO +WEEKLY_IMAGE --shard_file=shard.edge.yml
    SAVE IMAGE lucky-image:weekly-latest

weekly-nightly-image:
    FROM 84codes/crystal:master-ubuntu-22.04
    DO +WEEKLY_IMAGE --shard_file=shard.override.yml
    SAVE IMAGE lucky-image:weekly-nightly

WEEKLY_IMAGE:
    COMMAND
    ARG shard_file
    WORKDIR /workdir
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
    COPY +build-lucky/lucky /usr/bin/lucky
    RUN lucky init.custom test-project
    WORKDIR /workdir/test-project
    COPY $shard_file ./
    ENV SHARDS_OVERRIDE=/workdir/test-project/$shard_file
    RUN crystal tool format --check src spec config
    RUN yarn install --no-progress \
     && yarn dev \
     && shards install
    RUN crystal build src/start_server.cr
    RUN crystal build src/test_project.cr
    RUN crystal run src/app.cr
    ENTRYPOINT ["crystal", "spec"]
