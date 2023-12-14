FROM crystallang/crystal:1.6.2

# Install utilities required to make this Dockerfile run
RUN apt-get update && \
    apt-get install -y wget
# Add the nodesource ppa to apt. Update this to change the nodejs version.
RUN wget https://deb.nodesource.com/setup_16.x -O- | bash

# Apt installs:
# - nodejs (from above ppa) is required for front-end apps.
# - Postgres cli tools are required for lucky-cli.
# - tmux is required for the Overmind process manager.
RUN apt-get update && \
    apt-get install -y nodejs postgresql-client tmux && \
    rm -rf /var/lib/apt/lists/*

# NPM global installs:
#  - Yarn is the default package manager for the node component of a lucky
#    browser app.
#  - Mix is the default asset compiler.
RUN npm install -g yarn mix

# Install lucky cli
WORKDIR /lucky/cli
RUN git clone https://github.com/luckyframework/lucky_cli . && \
    git checkout v1.0.0 && \
    shards build --without-development && \
    cp bin/lucky /usr/bin

WORKDIR /app
ENV DATABASE_URL=postgres://postgres:postgres@host.docker.internal:5432/postgres
EXPOSE 3000
EXPOSE 3001

