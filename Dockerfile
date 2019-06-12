FROM crystallang/crystal:0.29.0

RUN apt-get update && \
  apt-get install -y libnss3 libgconf-2-4 chromium-browser build-essential curl libreadline-dev libevent-dev libssl-dev libxml2-dev libyaml-dev libgmp-dev golang-go postgresql postgresql-contrib && \
  # Set up node and yarn
  curl --silent --location https://deb.nodesource.com/setup_11.x | bash - && \
  apt-get install -y nodejs && \
  npm install -g yarn && \
  # Install Heroku CLI as process manager
  curl https://cli-assets.heroku.com/install.sh | sh && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set up git for use with Heroku specs
RUN git config --global user.email "lucky@fake.com" && \
  git config --global user.name "Lucky Dev"

# Set up credentials for Heroku specs
ARG HEROKU_EMAIL
ARG HEROKU_API_KEY

RUN echo 'machine git.heroku.com' >> ~/.netrc && \
  echo "  login $HEROKU_EMAIL" >> ~/.netrc && \
  echo "  password $HEROKU_API_KEY" >> ~/.netrc && \
  echo 'machine api.heroku.com' >> ~/.netrc && \
  echo "  login $HEROKU_EMAIL" >> ~/.netrc && \
  echo "  password $HEROKU_API_KEY" >> ~/.netrc && \
  chmod +x ~/.netrc

RUN mkdir /data
WORKDIR /data
COPY shard.* ./
RUN shards install
COPY . /data
RUN crystal build /data/src/lucky.cr -o /usr/local/bin/lucky && \
  chmod +x /usr/local/bin/lucky
