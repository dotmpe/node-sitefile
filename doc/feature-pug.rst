Pug route
=========

Notes
-----
- Setting ``compileDebug=true`` makes things worse, stacktraces simply start with::

    TypeError: str.split is not a function

- Take care with JavaScript variables in mixins, everything is global.
  Be sure to use ``let var...`` to declare local usage.
