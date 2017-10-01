ARG DCKR_TAG=latest
FROM bvberkum/ubuntu-treebox:$DCKR_TAG
MAINTAINER B. van Berkum <dev@dotmpe.com>


# Node version manager
#ENV NVM_DIR=/usr/local/nvm
#RUN curl -o- \
#  https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | \
#  bash && \
#  . $NVM_DIR/nvm.sh && \
#  nvm install stable


#RUN sudo npm install npm -g


ARG sf_checkout=dev

# Prepare for Sitefile
RUN \
  sudo mkdir -vp /src/github.com && \
  sudo chmod g+rw /usr/local/* /usr/local/lib/node_modules /src/github.com && \
  sudo chgrp staff /usr/local/* /usr/local/lib/node_modules /src/github.com
 
# Checkout Sitefile
RUN USER=$(whoami) && \
  ls -la /home/treebox /src/ /src/github.com && \
  mkdir -vp /src/github.com/bvberkum && \
  git clone https://github.com/bvberkum/node-sitefile.git \
    /src/github.com/bvberkum/node-sitefile && \
  sudo chown -R $USER:$USER /home/$USER /src/github.com/bvberkum && \
  cd /src/github.com/bvberkum/node-sitefile && \
  git checkout $sf_checkout

# Install Sitefile
RUN USER=$(whoami) && \
  cd /src/github.com/bvberkum/node-sitefile && \
  npm install --quiet grunt coffee-script && \
  npm install --quiet -g .


ENV site_src=github.com/bvberkum/node-sitefile
ENV site_repo=
ENV site_checkout=

RUN mkdir -vp /usr/local/share/sitefile
COPY ./entry.sh /usr/local/share/sitefile/entry.sh
ENTRYPOINT /usr/local/share/sitefile/entry.sh
