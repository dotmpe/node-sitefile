ARG DCKR_TAG=dev
FROM bvberkum/treebox:$DCKR_TAG
MAINTAINER B. van Berkum <dev@dotmpe.com>


ARG sf_checkout=dev

#ADD sudoers-treebox /etc/sudoers.d/treebox
USER root

# Prepare for Sitefile
RUN \
  sudo mkdir -vp /opt /src && \
  sudo chmod g+rw /usr/local/* /usr/local/lib/node_modules /opt /src && \
  sudo chgrp staff /usr/local/* /usr/local/lib/node_modules /opt /src
 
USER treebox

# Checkout Sitefile
RUN USER=$(whoami) && \
  mkdir -vp /opt/bvberkum /src/github.com/bvberkum && \
  git clone https://github.com/bvberkum/node-sitefile.git \
    /opt/bvberkum/node-sitefile && \
  sudo chown -R $USER:$USER /home/$USER /opt/bvberkum && \
  cd /opt/bvberkum/node-sitefile && \
  git checkout $sf_checkout && \
  ln -s /opt/bvberkum/node-sitefile /src/github.com/bvberkum/

# Install Sitefile
RUN USER=$(whoami) && \
  cd /opt/bvberkum/node-sitefile && \
  npm install --quiet grunt coffee-script && \
  npm install --quiet -g .

#RUN \
#  rm /etc/sudoers.d/treebox

ENV site_src=github.com/bvberkum/node-sitefile
ENV site_repo=
ENV site_version=

RUN mkdir -vp /usr/local/share/sitefile
COPY ./entry.sh /usr/local/share/sitefile/entry.sh
ENTRYPOINT ["/usr/local/share/sitefile/entry.sh"]
EXPOSE 7100-7109
CMD ["$site_src","$site_version","$site_repo"]

# Id: sitefile/0.0.7-dev
