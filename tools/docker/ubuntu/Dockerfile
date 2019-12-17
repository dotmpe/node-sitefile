ARG DCKR_TAG=dev
FROM dotmpe/treebox:$DCKR_TAG
MAINTAINER B. van Berkum <dev@dotmpe.com>

ARG sf_build_ver=dev
ARG username=treebox

USER root

ADD sudoers-treebox /etc/sudoers.d/treebox-2

# Prepare for Sitefile
ARG userdirs="/usr/local/lib/node_modules /opt/dotmpe /src/bitbucket.org/dotmpe /src/github.com/dotmpe"
RUN \
  mkdir -vp /home/$username $userdirs && \
  chmod -R g+rw /usr/local/* $userdirs && \
  chgrp -R staff /usr/local/* $userdirs && \
  chown -R $username:$username /home/$username $userdirs

USER $username

# Checkout Sitefile
RUN USER=$username && \
  git clone https://github.com/dotmpe/node-sitefile.git /opt/dotmpe/node-sitefile && \
  cd /opt/dotmpe/node-sitefile && \
  git checkout $sf_build_ver

# Install Sitefile
RUN USER=$username && \
  npm install -g grunt coffeescript && \
  cd /opt/dotmpe/node-sitefile && \
  npm install --quiet && \
  npm install --quiet -g && \
  mkdir -vp /usr/local/share/sitefile && \
  cp ./tools/docker/ubuntu/entry.sh /usr/local/share/sitefile/entry.sh

#RUN sudo rm /etc/sudoers.d/$username

ENV site_src=github.com/dotmpe/node-sitefile
ENV site_repo=
ENV site_version=

ENTRYPOINT ["/usr/local/share/sitefile/entry.sh"]
EXPOSE 7000-7099
CMD ["","",""]

LABEL \
    org.label-schema.name="$IMAGE_NAME:$DOCKER_TAG" \
    org.label-schema.build-date="$BUILD_DATE" \
    org.label-schema.version="0.0.7-dev" \
    org.label-schema.vcs-ref=$GIT_COMMIT \
    org.label-schema.vcs-url="https://github.com/dotmpe/node-sitefile" \
    org.label-schema.schema-version="1.0"


# Id: sitefile/0.0.7-dev
