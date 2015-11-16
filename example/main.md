Examples
========

- [ Server generated page ](./server-generated-page) - [(jade)](./server-generated-page.jade)
- [ Server generated stylesheet ](./server-generated-stylesheet) - [(stylus)](./server-generated-stylesheet.styl)
- [ Server generated script ](./server-generated-javascript) - [(coffee-script)](./server-generated-javascript.coffee)


Also see browser JavaScript console for proof of concept.
Extensions are mapped to one handler, no content negotiation.
Also paths with extensions may be forcefully redirected to the published
variants.

The current implementation maps a path extension to an Express handler. There is
little in the sense of true resources yet, the content is served with the local
path without extension as the URL. No negotiation, and most routers are rather
primitive and don't do much with headers or a lot of input sanitizing and error
handling.

- [ This is a markdown file ](./main.md)
- [ The ReadMe ](/ReadMe.rst) is formatted in Docutils reStructuredText
- The [media/](/media/), [public/components/](/components/) and [example/](/example/) directories are served directly from filesystem paths using the static router. The static router does not create indices, but redirects to the 'index' or 'main' files if present.

- [ Sh ](./sh-script) - [(script)](./sh-script.sh)


***

- [ Back to ReadMe ](/ReadMe)


