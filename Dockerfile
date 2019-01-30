FROM crystallang/crystal:0.27.0
RUN apt-get update && \
  apt-get install -y libnss3 libgconf-2-4 chromium-browser build-essential curl libreadline-dev libevent-dev libssl-dev libxml2-dev libyaml-dev libgmp-dev git golang-go postgresql postgresql-contrib && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Node dependency
RUN curl --silent --location https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get install -y nodejs
RUN npm install -g yarn

# Go dependency and forego process manager (avoids tmux/docker-compose bug with overmind)
RUN mkdir -p /usr/local/go
ENV GOPATH="/usr/local/go"
ENV PATH="/usr/local/go/bin:${PATH}"
RUN go get -u -f github.com/ddollar/forego

# Lucky cli
RUN git clone https://github.com/luckyframework/lucky_cli /usr/local/lucky_cli
WORKDIR "/usr/local/lucky_cli"
RUN git checkout v0.12.0
RUN shards install
RUN crystal build src/lucky.cr
RUN mv lucky /usr/local/bin

RUN mkdir /data
WORKDIR /data
ADD . /data
EXPOSE 5001
