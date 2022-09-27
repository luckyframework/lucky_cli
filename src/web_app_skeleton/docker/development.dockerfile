FROM crystallang/crystal:1.4.1

# Install utilities required to make this Dockerfile run
RUN apt-get update && \
    apt-get install -y wget gunzip

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

# Installs overmind, not needed if nox is the process manager.
RUN wget https://github.com/DarthSim/overmind/releases/download/v2.2.2/overmind-v2.2.2-linux-amd64.gz && \
    gunzip overmind-v2.2.2-linux-amd64.gz && \
    mv overmind-v2.2.2-linux-amd64 /usr/bin/overmind && \
    chmod +x /usr/bin/overmind

# Install lucky cli, TODO: fetch current lucky version from source code.
WORKDIR /lucky/cli
RUN git clone https://github.com/luckyframework/lucky_cli . && \
    git checkout v0.30.0 && \
    shards build --without-development && \
    cp bin/lucky /usr/bin

WORKDIR /app
ENV DATABASE_URL=postgres://postgres:postgres@host.docker.internal:5432/postgres
EXPOSE 5001

