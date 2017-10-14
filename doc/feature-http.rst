:created: 2017-08-26
:updated: 2017-10-14


Host
  ..
Server
  ..

Date
  ..

Last-Modified
-------------
Use-case for metadata interface; `DB Feature`_ docs.


CORS
----
Sitefile implements HTTP Access Control for incoming requests.

There are some improvements waiting in the backlog.
But for incoming requests, the ``Access-control-Allow-Origin`` [ACAO] header
is added if the origin or referer matches an entry in ``sitefile.upstream``.
See `cors`_ middleware.

Server CORS
-----------
To provide a start for similar restrictions on out-bound requests, the list
``sitefile.downstream`` is also added to the schema. Several components
in sitefile do server-side out-bound HTTP requests.
Efforts are to move these from `sitefile`_ and `router`_ core, and other
routers (..) to `deref`_.

It is estimated that rather than restricting, discovery and metadata annotation
of resources (wether remote, through outbound request) or not is the more
important design point though.


Allow
  ..

    TODO: JSON API `jsonapi`_


.. include:: .defaults.rst
