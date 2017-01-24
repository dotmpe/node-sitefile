
FROM ubuntu:12.04
MAINTAINER B. van Berkum <dev@dotmpe.com>


# Dev tooling
# Core tools
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive RUNLEVEL=1 apt-get install -y -qq \
  sudo man curl wget socat tmux tree ssh elinks \
  realpath \
  uuid-runtime \
  vim python make git build-essential \
  python-dev python-yaml \
  nodejs npm \
  rubygems \
  pandoc \
  graphviz


# Install PIP
RUN cd && \
  wget https://bootstrap.pypa.io/get-pip.py && \
  python get-pip.py


# Node version manager
#ENV NVM_DIR=/usr/local/nvm
#RUN curl -o- \
#  https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | \
#  bash && \
#  . $NVM_DIR/nvm.sh && \
#  nvm install stable


RUN npm install npm -g

ARG sf_checkout=r0.0.5

# Sitefile
RUN npm install -g coffee-script pm2 grunt grunt-cli
RUN gem install sass
RUN git clone \
  https://github.com/dotmpe/node-sitefile.git /src/node-sitefile && \
  cd /src/node-sitefile && \
  git checkout $sf_checkout && \
  npm install -g /src/node-sitefile


ARG site=node-sitefile
ARG repo=
ARG checkout=

RUN \
      mkdir -vp /usr/share/sitefile

COPY ./entry.sh /usr/share/sitefile/entry.sh
ENTRYPOINT /usr/share/sitefile/entry.sh $site $repo

