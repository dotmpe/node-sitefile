Node Sitefile
=============
Sitefile enables an Express HTTP server to set up from a local configuration file.

Description
------------
The intended purpose is to implement generic handlers for misc. file-based
resources that are suitable to be rendered to/accessed through HTTP and viewed 
in a web browser. For example the ReadMe file in many projects.

:TODO: The local configuration is used for further parametrization of the handlers.

Currently the following resources are supported:

- ``rst2html``: reStructuredText documents (depends on Python docutils)
- ``static``

and 

- ``redir``\ (ect)

Prerequisites
-------------
- Python docutils is not required, but is the only document format available.
- Installed ``coffee`` (coffee-script) globally (see ``bin/sitefile`` sha-bang).

Installation
------------
::

  npm install -g

Or make ``bin/sitefile`` available on your path, and install locally (w/o ``-q``).

Testing
-------
::

  npm install
  npm test

Test specifications are in ``test/jasmin/``.

Usage
------
In a directory containing a ``Sitefile.*``, run `sitefile` to start the server.

There are no further command line options.

Configuration
--------------
Supported Sitefile extensions/formats:

================ =======
\*.yaml \*.yml   YAML
\*.json          JSON
================ =======

Example Sitefile (json)::

  { 
    "sitefile": { "version": "0.1" },
    "routes": {
      "ReadMe": "rst2html:ReadMe",
      "media": "static:public/media",
      "todo": "todo-app:TODO.list",
      "": "redir:ReadMe"
    },
    "specs": {
      "static:": {
      },
      "rst2html:ReadMe": {
        ext: 'rst'
      }
    }
  }

:TODO: implement handler specs

:TODO: chalk
:TODO:
    | "compression": "^1.0.2",
    | "connect-flash": "latest",
    | "jade": "latest",
    | "method-override": "^2.3.2",
    | "node-uuid": "^1.4.3",
    | "notifier": "latest"

