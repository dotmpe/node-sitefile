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

# Sitefile
RUN USER=$(whoami) && \
  sudo npm install --quiet -g coffee-script pm2 grunt grunt-cli webpack && \
  grunt --version && \
  \
  sudo gem install --quiet sass && \
  sudo mkdir -vp /src/github.com/bvberkum && \
  sudo chown $USER:$USER /src/github.com/bvberkum

RUN USER=$(whoami) && \
  git clone https://github.com/bvberkum/node-sitefile.git \
    /src/github.com/bvberkum/node-sitefile && \
  sudo chown -R $USER:$USER /home/$USER /src/github.com/bvberkum && \
  cd /src/github.com/bvberkum/node-sitefile && \
  git checkout $sf_checkout && \
  npm install grunt && \
  sudo npm install --quiet -g . && \
  git status



ENV site_src=github.com/bvberkum/node-sitefile
ENV site_repo=
ENV site_checkout=

RUN mkdir -vp /usr/share/sitefile
COPY ./entry.sh /usr/share/sitefile/entry.sh
ENTRYPOINT /usr/share/sitefile/entry.sh "$site_src" "$site_checkout" "$site_repo"
