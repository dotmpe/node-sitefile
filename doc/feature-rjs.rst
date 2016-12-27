
Currently

- Webpack, gulp used to package commonjs2 modules (module.export)
  [features/webpack]
- Looking at creating a bundle extension type [features/bundles]
- Know-how to setup require.js tag with main and "boot" page from there,
  need a way to package rjs config (or particulary the module mapping parts).

  And including the CSS is something we can do simply ourselfs. [#]_


ToDo

CDN
  Want some CDN-like router.
  Provide a list at try each before serving as resource, redirect?

  TODO: provide lists of alternative URLs
  TODO: optionally have path attribute for routers that like both URL and local
  path.

  "bootstrap": "https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0-alpha.5/css/bootstrap.min"


----


.. [#] FAQ: RequireJS Advanced Usage - `What about loading CSS? <http://requirejs.org/docs/faq-advanced.html#css>`_.

    Here the authors of requirejs assume that having fallbacks to determine
    wether CSS has loaded is not reliable. Seems to me it is a
    robustness/maintainability problem, ie. wanting simplicity. Not reliability.

    But enfin the docs may be old. Pointing to Dojo #5402, which in turn
    points to some Mozilla ticket #185236. But that is solved and FireFox 9
    has Stylesheet load events. [#]_

.. [#] MDN: `Stylesheet load events <https://developer.mozilla.org/en-US/docs/Web/HTML/Element/link#Stylesheet_load_events>`_

