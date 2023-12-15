VERSION 0.7
FROM 84codes/crystal:1.6.2-ubuntu-22.04
WORKDIR /workdir

# all runs all recipes
all:
    WAIT
        BUILD +lint
        BUILD +specs
    END
    BUILD +task-spec
    BUILD +lucky-spec
    BUILD +integration-full-web-app
    BUILD +integration-full-web-app-noauth
    BUILD +integration-full-web-app-api
    BUILD +integration-full-web-app-api-noauth
    BUILD +integration-full-web-app-dir

# gh-action-initial runs only the necessary initial recipes
gh-action-initial:
    BUILD +format-check
    BUILD +lint
    BUILD +specs

# gh-action-integration runs all integration specs
gh-action-integration:
    BUILD +task-spec
    BUILD +lucky-spec
    BUILD +integration-full-web-app
    BUILD +integration-full-web-app-noauth
    BUILD +integration-full-web-app-api
    BUILD +integration-full-web-app-api-noauth
    BUILD +integration-full-web-app-dir

# format-check checks the format of source files
format-check:
    COPY --dir src ./
    COPY --dir spec ./
    RUN crystal tool format --check src spec

# lint runs ameba code linter
lint:
    FROM ghcr.io/crystal-ameba/ameba:1.5.0
    COPY . ./
    RUN ameba

# specs runs unit tests
specs:
    COPY . ./
    RUN shards install
    RUN crystal spec --tag "~integration"

# task-spec runs lucky command tests
task-spec:
    COPY +integration-base-image/lucky /usr/bin/lucky
    COPY . ./
    RUN shards build lucky.hello_world --without-development
    ENV LUCKY_ENV=test
    ENV RUN_SEC_TESTER_SPECS=0
    ENV RUN_HEROKU_SPECS=0
    RUN crystal spec --tag task

# lucky-spec runs lucky command tests
lucky-spec:
    COPY +integration-base-image/lucky /usr/bin/lucky
    COPY . ./
    RUN shards build lucky.hello_world --without-development
    ENV LUCKY_ENV=test
    ENV RUN_SEC_TESTER_SPECS=0
    ENV RUN_HEROKU_SPECS=0
    RUN crystal spec --tag lucky

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

# integration-full-web-app-dir tests lucky full web app in different directory
integration-full-web-app-dir:
    FROM earthly/dind:alpine
    COPY docker-compose.yml ./
    WITH DOCKER \
        --compose docker-compose.yml \
        --load lucky-image:latest=+integration-image-dir
        RUN docker run --network=host lucky-image:latest
    END

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
                lucky-image:latest \
                spec -Dwith_sec_tests
    END

integration-base-image:
    RUN apt-get update \
     && apt-get install -y postgresql-client ca-certificates curl gnupg \
     && mkdir -p /etc/apt/keyrings \
     && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
     && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
     && apt-get update \
     && apt-get install -y nodejs \
     && npm install --global yarn
    WORKDIR /lucky_cli
    COPY --dir src ./
    COPY --dir fixtures ./
    COPY shard.yml ./
    RUN shards build lucky --without-development
    RUN cp bin/lucky /usr/bin/
    SAVE ARTIFACT ./bin/lucky
    WORKDIR /workdir

integration-image:
    FROM +integration-base-image
    RUN lucky init.custom test-project
    WORKDIR /workdir/test-project
    RUN crystal tool format --check src spec config
    RUN shards install
    RUN crystal build src/start_server.cr
    RUN crystal build src/test_project.cr
    RUN crystal run src/app.cr
    ENTRYPOINT ["crystal", "spec"]
    SAVE IMAGE lucky-image:base

integration-image-noauth:
    FROM +integration-base-image
    RUN lucky init.custom test-project --no-auth
    WORKDIR /workdir/test-project
    RUN crystal tool format --check src spec config
    RUN shards install
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

integration-image-dir:
    FROM +integration-base-image
    RUN mkdir -p my-project
    RUN lucky init.custom test-project --dir my-project
    WORKDIR /workdir/my-project/test-project
    RUN crystal tool format --check src spec config
    RUN shards install
    RUN crystal build src/start_server.cr
    RUN crystal build src/test_project.cr
    RUN crystal run src/app.cr
    ENTRYPOINT ["crystal", "spec"]
    SAVE IMAGE lucky-image:dir

integration-image-security:
    FROM +integration-base-image
    RUN npm install --global @neuralegion/nexploit-cli --unsafe-perm=true
    RUN lucky init.custom test-project --with-sec-test
    WORKDIR /workdir/test-project
    RUN crystal tool format --check src spec config
    RUN shards install
    RUN crystal build src/start_server.cr
    RUN crystal build src/test_project.cr
    RUN crystal run src/app.cr
    ENV LUCKY_ENV=test
    ENV RUN_SEC_TESTER_SPECS=1
    SAVE IMAGE lucky-image:security
