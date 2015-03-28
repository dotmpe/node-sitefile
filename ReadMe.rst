Node Sitefile
=============
Bootstrap webserver for misc. resources using Sitefile.


Sitefile (json)::

  { 
    "sitefile": { "version": "0.1" },
    "routes": {
      "ReadMe": "rst2html:ReadMe.rst",
      "media": "static:public/media",
      "todo": "todo-app:TODO.list",
      "": "redir:ReadMe"
    },
    "specs": {
      "static:": {
      },
      "rst2html:ReadMe": {
      }
    }
  }

TODO add: LICENSE-GPLv3
