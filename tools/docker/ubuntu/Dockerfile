ARG DCKR_TAG=dev
FROM bvberkum/treebox:$DCKR_TAG
MAINTAINER B. van Berkum <dev@dotmpe.com>


ARG sf_checkout=dev

ADD sudoers-treebox /etc/sudoers.d/treebox
ARG username=treebox

USER root

# Prepare for Sitefile
RUN env && \
  mkdir -vp /opt /src && \
  chmod g+rw /usr/local/* /usr/local/lib/node_modules /opt /src && \
  chgrp staff /usr/local/* /usr/local/lib/node_modules /opt /src && \
  mkdir /home/$USER && \ 
  chown -R $USER:$USER /home/$USER /opt/bvberkum

USER $username

# Checkout Sitefile
RUN USER=$username && \
  mkdir -vp /opt/bvberkum /src/github.com/bvberkum && \
  git clone https://github.com/bvberkum/node-sitefile.git \
    /opt/bvberkum/node-sitefile && \
  cd /opt/bvberkum/node-sitefile && \
  git checkout $sf_checkout && \
  ln -s /opt/bvberkum/node-sitefile /src/github.com/bvberkum/

# Install Sitefile
RUN USER=$username && \
  cd /opt/bvberkum/node-sitefile && \
  npm install --quiet grunt coffee-script && \
  npm install --quiet -g .


RUN rm /etc/sudoers.d/$username

ENV site_src=github.com/bvberkum/node-sitefile
ENV site_repo=
ENV site_version=

RUN mkdir -vp /usr/local/share/sitefile
COPY ./entry.sh /usr/local/share/sitefile/entry.sh
ENTRYPOINT ["/usr/local/share/sitefile/entry.sh"]
EXPOSE 7000-7099
CMD ["$site_src","$site_version","$site_repo"]

# Id: sitefile/0.0.7-dev
