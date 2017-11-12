Dockerfile and autobuilt image
==============================

====================== =============
Tag                    Compressed
---------------------- -------------
0.0.7-dev              605 MB
latest                 605 MB
ubuntu-xenial-r0.0.7   415 MB
====================== =============


Usage::

	docker run bvberkum/node-sitefile <site-src> <site-repo> <site-ver>


- Entrypoint allows to serve from a GIT repository, and updates it (on start) if
  site-ver corresponds to a GIT tag or branch.

- Moves CWD to ``/src/<site-src>``.

  TODO: clone elsewhere to avoid issues with permissions, and serving multiple
  version of the same repo. Probably /var/www/...

- Presence of ``package.json`` triggers ``npm install``.

