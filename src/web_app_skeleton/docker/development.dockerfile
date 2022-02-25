FROM crystallang/crystal:1.1.1

# Add the nodesource ppa to apt.
RUN wget https://deb.nodesource.com/setup_16.x -O- | bash

# Install nodejs, npm, yarn
RUN apt-get update
RUN apt-get install -y nodejs
RUN npm install -g yarn mix

# Install postgres cli tools
RUN apt-get install -y postgresql-client

# Installs overmind, not needed if nox is the process manager.
RUN apt-get install -y tmux && \
    wget https://github.com/DarthSim/overmind/releases/download/v2.2.2/overmind-v2.2.2-linux-amd64.gz && \
    gunzip overmind-v2.2.2-linux-amd64.gz && \
    mv overmind-v2.2.2-linux-amd64 /usr/bin/overmind && \
    chmod +x /usr/bin/overmind

# Install lucky cli, TODO: fetch current lucky version from source code.
WORKDIR /lucky/cli
RUN git clone https://github.com/luckyframework/lucky_cli . && \
    git checkout v0.29.0 && \
    shards build --without-development && \
    cp bin/lucky /usr/bin

WORKDIR /app
ENV DATABASE_URL=postgres://postgres:postgres@host.docker.internal:5432/postgres
EXPOSE 5001

