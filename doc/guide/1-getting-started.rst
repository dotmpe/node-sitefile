Getting Started
===============

Run your first Sitefile
-----------------------
Define a file like the following to let sitefile add every known file to the
site. TODO: You can generate a YAML file with::

  sitefile init [AUTO-EXPORT-ROUTERS...]

The ``[...]`` argument indicates an optional space separated list of router
names. In any case a simple example Sitefile is generated to start with.

Sitefile.yml::

    sitefile: 0.0.5-dev
    paths:
      routers: [
        'sitefile:example/routers'
        './routers'
      ]
    auto-export:
      options: [ '*' ]
      routes: [ '*' ]
    routes: {}
    options: {}


- TODO: this should export all known routers using their supplied default mappings
- TODO: this should include the example extension router


Now, upon executing `sitefile` next to this file, every route on the site is
printed out and served via HTTP.
Depending on the files and routers the paths are now available as HTML, JS, CSS
or more complex resources and can be viewed in a local browser.

The asterixes in the ``auto-export`` attribute causes `Sitefile` to use
a presupplied example mapping and options for every available router.

You may want to review the `available routers`_  depending on the files you wish
to serve, and instead provide a restricted list of routers to auto-export.


Building a local website
------------------------
Next you will want to build a site out of standalone files,
basicly by filling out the ``routes`` and ``options`` attributes of the
`Sitefile`. These and other available attributes are documented at
`Sitefile format`_, and that concludes the 'Getting Started' guide.

- TODO: the routers and their default routes/options should be documented

FIXME: sitefile currently cannot edit content, except for some database based
handlers.
However Sf 0.0.5 does accepts new routers.
You can continue to read about `adding a local extension router`_.


.. _adding a local extension router: ./2-adding-a-local-extension-router
.. _available routers: TODO:router-docs
.. _sitefile format: TODO:sitefile-format-spec

