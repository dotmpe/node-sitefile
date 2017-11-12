[comment]: # This would be the hub.docker.com ReadMe..

[![docker autobuild status](https://img.shields.io/docker/build/bvberkum/node-sitefile.svg)](https://hub.docker.com/r/bvberkum/node-sitefile/builds/)
[![last commit r0.0.7](https://img.shields.io/github/last-commit/bvberkum/node-sitefile/r0.0.7.svg)](https://github.com/bvberkum/node-sitefile/blob/r0.0.7/index.rst)

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
