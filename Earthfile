VERSION 0.7
FROM 84codes/crystal:1.6.2-ubuntu-22.04
WORKDIR /workdir

# gh-action-initial runs only the necessary initial recipes
gh-action-initial:
    BUILD +format-check
    BUILD +lint
    BUILD +specs

# gh-action-integration runs all integration specs
gh-action-integration:
    BUILD +integration-specs
    BUILD +integration-full-web-app
    BUILD +integration-full-web-app-noauth
    BUILD +integration-full-web-app-api
    BUILD +integration-full-web-app-api-noauth
    BUILD +integration-full-web-app-dir

# gh-action-security runs all security tests (requires secrets)
gh-action-security:
    BUILD +integration-sec-tester

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
    FROM +base-image
    COPY --dir fixtures ./
    RUN shards install
    RUN crystal spec --tag "~integration"

# lint runs ameba code linter
lint:
    FROM ghcr.io/crystal-ameba/ameba:1.5.0
    COPY --dir src ./
    COPY --dir spec ./
    RUN ameba

# integration-specs runs lucky command tests
integration-specs:
    FROM +base-image
    COPY +build-lucky/lucky /usr/bin/lucky
    COPY fixtures/hello_world.cr fixtures/
    COPY fixtures/tasks.cr fixtures/
    RUN shards build lucky.hello_world --without-development
    ENV LUCKY_ENV=test
    RUN crystal spec --tag integration

# integration-full-web-app tests lucky full web app
integration-full-web-app:
    FROM earthly/dind:alpine
    COPY docker-compose.yml ./
    WITH DOCKER \
        --compose docker-compose.yml \
        --load lucky-image:latest=+integration-image
        RUN docker run --network=host lucky-image:latest
    END

# integration-full-web-app-noauth tests lucky full web app with no auth
integration-full-web-app-noauth:
    FROM earthly/dind:alpine
    COPY docker-compose.yml ./
    WITH DOCKER \
        --compose docker-compose.yml \
        --load lucky-image:latest=+integration-image-noauth
        RUN docker run --network=host lucky-image:latest
    END

# integration-full-web-app-api tests lucky full web app with api
integration-full-web-app-api:
    FROM earthly/dind:alpine
    COPY docker-compose.yml ./
    WITH DOCKER \
        --compose docker-compose.yml \
        --load lucky-image:latest=+integration-image-api
        RUN docker run --network=host lucky-image:latest
    END

# integration-full-web-app-api-noauth tests lucky full web app with api and no auth
integration-full-web-app-api-noauth:
    FROM earthly/dind:alpine
    COPY docker-compose.yml ./
    WITH DOCKER \
        --compose docker-compose.yml \
        --load lucky-image:latest=+integration-image-api-noauth
        RUN docker run --network=host lucky-image:latest
    END

# integration-full-web-app-dir same as +integration-full-web-app, but uses different directory
integration-full-web-app-dir:
    COPY +build-lucky/lucky /usr/bin/lucky
    RUN mkdir -p my-project
    RUN lucky init.custom test-project --dir my-project
    WORKDIR /workdir/my-project/test-project
    RUN grep "lucky" -qz src/shards.cr

# integration-sec-tester tests lucky full app with security tester enabled
integration-sec-tester:
    FROM earthly/dind:alpine
    COPY docker-compose.yml ./
    WITH DOCKER \
        --compose docker-compose.yml \
        --load lucky-image:latest=+integration-image-security
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

# weekly-latest-full-web-app tests lucky full web app (crystal: nightly) for more insight into upcoming crystal versions
weekly-nightly-full-web-app:
    FROM earthly/dind:alpine
    COPY docker-compose.yml ./
    WITH DOCKER \
        --compose docker-compose.yml \
        --load lucky-image:latest=+weekly-nightly-image
        RUN docker run --network=host lucky-image:latest
    END

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

integration-base-image:
    RUN apt-get update \
     && apt-get install -y postgresql-client ca-certificates curl gnupg libnss3 libnss3-dev wget \
     && mkdir -p /etc/apt/keyrings \
     && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
     && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
     && apt-get update \
     && apt-get install -y nodejs \
     && npm install --global yarn \
     && wget -O /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
     && apt-get install -y /tmp/google-chrome-stable_current_amd64.deb \
     && export CHROME_BIN=/usr/bin/google-chrome
    COPY +build-lucky/lucky /usr/bin/lucky

integration-image:
    FROM +integration-base-image
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

integration-image-noauth:
    FROM +integration-base-image
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

integration-image-api:
    FROM +integration-base-image
    RUN lucky init.custom test-project --api
    WORKDIR /workdir/test-project
    RUN crystal tool format --check src spec config
    RUN shards install
    RUN crystal build src/start_server.cr
    RUN crystal build src/test_project.cr
    RUN crystal run src/app.cr
    ENTRYPOINT ["crystal", "spec"]
    SAVE IMAGE lucky-image:api

integration-image-api-noauth:
    FROM +integration-base-image
    RUN lucky init.custom test-project --api --no-auth
    WORKDIR /workdir/test-project
    RUN crystal tool format --check src spec config
    RUN shards install
    RUN crystal build src/start_server.cr
    RUN crystal build src/test_project.cr
    RUN crystal run src/app.cr
    ENTRYPOINT ["crystal", "spec"]
    SAVE IMAGE lucky-image:api-noauth

integration-image-security:
    FROM +integration-base-image
    RUN lucky init.custom test-project --with-sec-test
    WORKDIR /workdir/test-project
    RUN crystal tool format --check src spec config
    RUN yarn install --no-progress \
     && yarn dev \
     && shards install
    ENV LUCKY_ENV=test
    ENV RUN_SEC_TESTER_SPECS=1
    # Patch for sec_tester
    RUN sed -i '131s/as_f/as_i/' lib/sec_tester/src/sec_tester/scan.cr
    ENTRYPOINT ["crystal", "spec", "-Dwith_sec_tests"]
    SAVE IMAGE lucky-image:security

weekly-latest-image:
    FROM 84codes/crystal:latest-ubuntu-22.04
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
     && apt-get install -y /tmp/google-chrome-stable_current_amd64.deb \
     && export CHROME_BIN=/usr/bin/google-chrome
    COPY +build-lucky/lucky /usr/bin/lucky
    RUN lucky init.custom test-project
    WORKDIR /workdir/test-project
    COPY shard.edge.yml ./
    RUN export SHARDS_OVERRIDE=$(realpath shard.edge.yml)
    RUN crystal tool format --check src spec config
    RUN yarn install --no-progress \
     && yarn dev \
     && shards install
    RUN crystal build src/start_server.cr
    RUN crystal build src/test_project.cr
    RUN crystal run src/app.cr
    ENTRYPOINT ["crystal", "spec"]
    SAVE IMAGE lucky-image:weekly-latest

weekly-nightly-image:
    FROM 84codes/crystal:master-ubuntu-22.04
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
     && apt-get install -y /tmp/google-chrome-stable_current_amd64.deb \
     && export CHROME_BIN=/usr/bin/google-chrome
    COPY +build-lucky/lucky /usr/bin/lucky
    RUN lucky init.custom test-project
    WORKDIR /workdir/test-project
    COPY shard.override.yml ./
    RUN export SHARDS_OVERRIDE=$(realpath shard.override.yml)
    RUN crystal tool format --check src spec config
    RUN yarn install --no-progress \
     && yarn dev \
     && shards install
    RUN crystal build src/start_server.cr
    RUN crystal build src/test_project.cr
    RUN crystal run src/app.cr
    ENTRYPOINT ["crystal", "spec"]
    SAVE IMAGE lucky-image:weekly-nightly
