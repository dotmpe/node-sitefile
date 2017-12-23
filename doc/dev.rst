Main Development Document
=========================

.. include:: .defaults.rst

.. contents::

This document introduces Sitefile conceptually, and then continues to outline
its current focus, setup and results.


Intro
------
There are many possibly useful directions. Most high flying ideas go to the
suites in the `Packaging Feature`_ docs.

Here is some inspiration seen elsewhere. There should be some nice examples of
web-typography, but I can retrieve none for now.

* The IETF HTML viewer is an example of a worthwile upgrade to plain text
  documents. And while on the monospaced theme, don't forget the joy of proper
  terminal displays styling. E.g. ansigarden.com_ for the old IBM code page 437
  standard of temrinal art.

* Investopedia has a very nice infinite-document-style client, putting all of
  its articles in sequence automatically.

During the intial development, a `Sitefile Planet`_ document was created to
analyze the alteratives in the field, and maybe to note the status-quo wrt.
hypertext publishing. Regardless of the platform.


Documentation
-------------
The main document format is reStructuredText. But all of its structure is
manual. And it is quite varied, non-uniform with lots of development and initial
analysis, ideas, todos, etc.. Besides the section `Main Features`_ on focus, and
the feature documents, the most definite parts are or should be in the Changelog_
and the more detailed logs in ``doc/dev/``.

To make sense of the available documentation a definite overview is created
in `Documentation Overview`_, included here as appendix `Documentation Index`_.


Main Features
--------------
These are features in development for the v0.1/v0.0.1 roadmap.

.. note::

  All of this is revised regularly and will change before 0.1 and 1.0.
  Below are the working parts listed, with issues, notes on progress with links
  to dev docs.


1. .. _feature-1:

   Hypermedia representation generators, interface to different types of
   content (router names and dev. doc-ref given):

   1. Text markup languages (md, rst, textile, mediawiki; `features/text`_)
   2. Server side templates (pug)
   3. Scripts (js, coffee, requirejs)
   4. Stylesheets (sass `features/build`_, less, styl)
   5. Diagrams (networks, UML, GANTT; `features/graphics`_)
   6. Data cache and storage, querying (bookshelf-api, OData, Bootstrap et al.;
      `features/db`_)
   7. Resources (http)
   8. Services, other integrations

      1. PM2 module to run other node, or sitefile instances (`features/pm`_)

            Work-in-Progress:


2. .. _feature-2:

   Execution environment standards:

   1. Hypertext protocol support (`features/http`_).

      1. Temporary and Permanent HTTP Redirect
      2. Static content, ie. direct HTTP-to-filesystem
      3. Resources, ie. abstraction away from specific resource representation
      4. Proxy resources

      Work in progress: proxy resources

      5. Valid MIME and HTTP 1.1

           Work-in-Progress: in-depth HTTP validation is a payed for job.
           At least some work on regular headers is required.

   2. ..

        TODO: describe Command line modes, shell and os env

      YAML and JSON based setup.

        Work-in-Progress: Look at alternatively to operate from argv/env iso.
        local Sitefile
        Also, router/sitefile versions. Possible data migration schemes.

      ..

        Ideas: conglomerate's of site(file)s, nested sitefiles, syndication and
        API exposure.

   3. Data infra and metadata schema

        Work in Progress:


3. .. _feature-3:

   Build, Installables and Addons:

   1. Packages and components

      - Add `sitefile.paths.routers` paths for router lookup, ie. to include
        extension routers.
      - Set `sitefile.packages` and `sitefile.path.packages` to load additional
        non-router packages, container either ``context-protype`` mixins or
        ``middeware`` components.

      ..

        Work-in-progress: user-defined addons, extendable resources/routers,
        customizations (`features/route`_).

        Also, abstract resources (ie. `features/http`_, `features/db`_).

      ..

        Idea: nothing is packaged yet, see suites (`features/packaging`_).
        Some build

   2. Dependencies

      - Using ``/vendor/<lib>.<ext>`` URL to access prerequisite libraries of
        JS or CSS, either from local path or using remote URL redirect
        (``router:http.vendor``).

      - Besides JS and CSS, Sitefile allows for to add clients with some routers
        using ``sitefile.options.{local,global}``.

      - Beyond that, Sitefile depends on its client based on require.js
        to load CoffeeScript or other media like stylesheets, fonts, templates.

      - The library to file/URL map (``cdn.json``) is both used by the
        ``http.vendor`` router and to configure the ``require.js`` root
        context's path option, along with ``cdn-deps.json`` as shims to
        map our library dependencies.

      ..

        Work-in-progress: this setup does not allow for extensions (routers, other
        components) to register for certain prerequisites.

      ..

        XXX: register JS/CSS/media/... dependencies with components. Built more
        of a framework for vendor/rjs-root context within sitefile than a simple
        static JSON.

        Depends on build/packaging process and DHTML/Client and would influence
        current rjs setup. (`features/rjs`)


   5. work in progress: a default or 'base' client,
      with decent support for all routes (`features/client`_)


Issues
------
- Latest/r0.0.7 docker has issues with hostname in some setups.
  Using ubuntu-xenial-r0.0.7 works until resolved.

  Probably caused by local user config not being used, but the one included
  with node-sitefile. Need to think about install vs. src locations a bit.

- Docker entry does not have GIT LFS, assets like favicon are missing.


Appendices
==========

Documentation Index
-------------------
.. include:: index.rst
   :start-after: .. index


Branch docs
------------
.. include:: scm-branches.rst
   :start-line: 4
