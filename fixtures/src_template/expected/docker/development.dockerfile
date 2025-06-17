FROM crystallang/crystal:1.16.1

# Install utilities required to make this Dockerfile run
RUN apt-get update && \
    apt-get install -y wget

# Install lucky cli
WORKDIR /lucky/cli
RUN git clone https://github.com/luckyframework/lucky_cli . && \
    git checkout v1.3.0 && \
    shards build --without-development && \
    cp bin/lucky /usr/bin

WORKDIR /app
ENV DATABASE_URL=postgres://postgres:postgres@host.docker.internal:5432/postgres
EXPOSE 3000
EXPOSE 3001

