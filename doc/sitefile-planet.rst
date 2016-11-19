Sitefile planet
---------------
A section looking at alternatives or comparable projects from the Node.JS sphere.

.. I don't know about many Node.JS frameworks. Express obviously, but only
   heard a bit of Grunt and Yeoman.

   I'm biased to reStructuredText since that's been my note format for over 10
   years, and have not really found anyting as expressive.


`harp <http://harpjs.com>`_
  enables filesystem-based content for websites too, but does so in a
  project-generator type of fashion.

  Sitefile is unobtrusive, except for some configuration file.
  Also sitefile does not focus on providing an development platform,
  harp is far more extended. some concepts such as asset management (styles,
  images) are interesting.

`Meteor <https://www.meteor.com/>`_
  Like harp, Meteor is an development platform.
  Meteor especially promotes its generator/deploy mechanism.
  More than I've seen with harp though, Meteor provides for an re-integration of
  the client and backend sides, presumably using web sockets.
  (Meteor renders client side, presumably using some web-sockets based RPC.
  It needs add. components to render server-side for non-JS clients)

  There is no discussion on the deployment systems, and I presume this makes the
  only valid target servers meteor enabled servers. It would be great is the
  server for the integrated backend/frontend environment was portable or
  cross-compilable. See also HaXe_.

`Docutils reStructuredText <http://docutils.sourceforge.net/rst.html>`_
  It does not appear that rSt is that popular with the Node.JS crowd.
  Even with Sphynx and the like it looks like it has not gained much traction beyond Python.

  One popular? node module is actually to `convert rst to markdown <https://nodejsmodules.org/pkg/rst2mdown>`_.

`Node.JS`
  It's so simple to aggregate rich apps with Node.JS and NPM that Sitefile unless it grows is not so much needed.
  Even without Express and standard libraries only: https://gist.github.com/ryanflorence/701407
  And just for static files: http://www.sitepoint.com/serving-static-files-with-node-js/

`node-static <http://harpjs.com>`_
  Makes easy streaming of files. Would be nice to integrate with for media centers
  with Sitefile HTML UI?

`wiki-server <https://www.npmjs.com/package/wiki-server>`_
  "A Federated Wiki Server"

GIT based wikis
  - Gollum
  - Realms_, a "Git based wiki written in Python Inspired by Gollum, Ghost, and Dillinger"
  - `Jingo <https://github.com/claudioc/jingo>`_ "Node.js based Wiki".

    Something to look at. Given its GIT based store and Wiki formatting this may provide for another interesting file-based content router.

Editors
  Dillinger_
    "Dillinger is a cloud-enabled, mobile-ready, offline-storage, AngularJS
    powered HTML5 Markdown editor."

`Ghost <https://github.com/tryghost/Ghost>`_
  "A simple, powerful publishing platform https://ghost.org"


.. _realms: https://github.com/scragg0x/realms-wiki
.. _dillinger: http://dillinger.io/



reStructured Text documenation tooling
''''''''''''''''''''''''''''''''''''''

`Sphynx <http://sphinx-doc.org/>`_
  Python documentation generator based on Du (ie. rSt to HTML, LaTex, etc.)

  Provides some additional reStructuredText directives, uses its own
  publisher chain.

`Nabu <https://bitbucket.org/blais/nabu>`_
  Document publishing using text files.

  Provides an extractor framework for regular Du transforms to turn into data
  extractors.
  Extractors are paired with storage instances, of which Nabu provides some SQL
  compatible baseclasses.
  Indexed external metadata can then by used by other systems, such as a blog
  publisher.

  Potentially, Du transforms can rewrite documents and ie. enrich references and
  various sorts of embedded metadata.
  For a complete setup, this would require a reStructuredText (re)writer however.

`pandoc <http://johnmacfarlane.net/pandoc/>`_
  A pretty heroic "swiss-army knive" doc-conv effort in Haskell.

  It is not completely compatible with Python Docutils rSt, but does an pretty
  amazing job on converting rSt and a few dozen other formats with each other.
  Worth a mention, without it being used by sitefile (yet).

.. if they ever are usable here perhaps mention Blue-Lines, or Scrow.


Other Non-NodeJS-related Topics
'''''''''''''''''''''''''''''''''

`Markdown <http://daringfireball.net/projects/markdown/>`_
  Markdown is less well defined and in general far less capable than reStructuredText,
  but very suited for simple marked up text to HTML conversions.

  Its simplicity is only one likely cause that it is far more popular across various web-related projects.
  Commercial suites from Atlassian elaborate on a similar plain text editor formats.

`TiddlyWiki <http://tiddlywiki.com>`_
  "a non-linear personal web notebook"

  Not opened in years and never really used it, but the concept is really nice.
  May already provide some Node.JS integration.

`Jekyll <https://github.com/jekyll/jekyll>`_
  "Jekyll is a blog-aware, static site generator in Ruby"

  :via: GitHub Pages - `Using Jekyll with Pages <https://help.github.com/articles/using-jekyll-with-pages/>`_

`HaXe <http://haxe.org>`_
  Has nothing to do with publishing, but looking at deployment options it has some
  interesting feats to mention in addition to Harp, Meteor and Jekyll.

  HaXe is an ECMA-script language with compilers for a number of other
  high-level languages, including PHP and JS. It also provides for
  RPC setups for use on clients, and an ORM system.
  Its API is nearly cross-platform. Making it very interesting to use it for
  writing not only clients, but also servers that support a certain publishing
  stack.


