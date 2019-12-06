# ![](assets/logo-file-text-8bc34a.png) Sitefile [![docker autobuild status](https://img.shields.io/docker/build/bvberkum/node-sitefile.svg)](https://hub.docker.com/r/bvberkum/node-sitefile/builds/) [![last commit r0.0.7](https://img.shields.io/github/last-commit/dotmpe/node-sitefile/r0.0.7.svg)](https://github.com/dotmpe/node-sitefile/blob/r0.0.7/index.rst) [![Badge Badge](http://doyouevenbadge.com/github.com/github.com/dotmpe/node-sitefile)](http://doyouevenbadge.com/report/github.com/github.com/dotmpe/node-sitefile)


A node.js + express websitebuilder. Based on a metadata file called `Sitefile`
and regular documents, available at the filesystem.

Usage:
```
docker run bvberkum/node-sitefile <site-src> <site-repo> <site-ver>
```

Default example:
```bash
docker run \
  -p 7011:7011 \
  -e SITEFILE_PORT=7011 \
  --volume /srv:/srv:rw \
  --volume /etc/localtime:/etc/localtime:ro \
  bvberkum/node-sitefile:0.0.7-dev \
    github.com/dotmpe/node-sitefile \
    https://github.com/dotmpe/node-sitefile \
    r0.0.7
```

Under development, see doc/feature-docker.rst docs.


## bvberkum/sitefile

Branch                              | Dockerfile              | Tag           
----------------------------------- | ------------------------| ---------------
``/^r([0-9\.]+[-a-z0-9+_-]*)/``     | ``tools/docker/ubuntu`` | {\1}-dev

Tag                                 | Dockerfile              | Tag           
----------------------------------- | ------------------------| ---------------
docker-latest                       | ``tools/docker/ubuntu`` | latest      
``/^v([0-9\.]+[-a-z0-9+_-]*)/``     | ``tools/docker/ubuntu`` | {\1}

Dev builds from ``treebox:dev``, latest from ``:latest`` and tagged releases are
matched with the latest treebox stable version (0.0.1).
