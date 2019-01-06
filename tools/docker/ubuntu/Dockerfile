ARG DCKR_TAG=dev
FROM bvberkum/treebox:$DCKR_TAG
MAINTAINER B. van Berkum <dev@dotmpe.com>

ARG sf_build_ver=dev
ARG username=treebox

USER root

ADD sudoers-treebox /etc/sudoers.d/treebox-2

# Prepare for Sitefile
ARG userdirs="/usr/local/lib/node_modules /opt/bvberkum /src/bitbucket.org/bvberkum /src/github.com/bvberkum "
RUN \
  mkdir -vp /home/$username $userdirs && \
  chmod -R g+rw /usr/local/* $userdirs && \
  chgrp -R staff /usr/local/* $userdirs && \
  chown -R $username:$username /home/$username $userdirs

USER $username

# Set LTS and get SASS and SQLite build
RUN n lts && npm install -g node-sass@4.10.0 sqlite3@4.0.4 coffee-script@1.12.7

# Checkout Sitefile
RUN USER=$username && \
  git clone https://github.com/bvberkum/node-sitefile.git /opt/bvberkum/node-sitefile && \
  cd /opt/bvberkum/node-sitefile && \
  git checkout $sf_build_ver

# Install Sitefile
RUN USER=$username && \
  npm install -g grunt coffee-script && \
  cd /opt/bvberkum/node-sitefile && \
  npm install --quiet . && \
  npm install --quiet -g .


#RUN sudo rm /etc/sudoers.d/$username

ENV site_src=github.com/bvberkum/node-sitefile
ENV site_repo=
ENV site_version=

RUN mkdir -vp /usr/local/share/sitefile
COPY ./entry.sh /usr/local/share/sitefile/entry.sh
ENTRYPOINT ["/usr/local/share/sitefile/entry.sh"]
EXPOSE 7000-7099
CMD ["","",""]

LABEL \
    org.label-schema.name="$IMAGE_NAME:$DOCKER_TAG" \
    org.label-schema.build-date="$BUILD_DATE" \
    org.label-schema.version="0.0.7-dev" \
    org.label-schema.vcs-ref=$GIT_COMMIT \
    org.label-schema.vcs-url="https://github.com/bvberkum/node-sitefile" \
    org.label-schema.schema-version="1.0"


# Id: sitefile/0.0.7-dev
