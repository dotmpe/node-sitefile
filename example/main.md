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


# Polymer

- [ Polymer Example ](./polymer-example)
- [ Polymer Simple Custom Element Example ](./polymer-custom)
- [ Polymer App Router ](./polymer-app-router.html)


# Graphviz

From [ Graphviz dotguide ](http://www.graphviz.org/pdf/dotguide.pdf)

![ Small dot graph ](./graphviz-small-graph.dot "Small diagram")

![ Fancy dot graph ](./graphviz-fancy-graph.dot "Fancy diagram")

![ Polygonal labels dot graph ](./graphviz-polygonal-labels-graph.dot "Diagram with polygonal labels")

![ Record labels dot graph ](./graphviz-record-labels-graph.dot "Diagram with record labels")

![ HTML-like tables dot graph ](./graphviz-html-labels-graph.dot "Diagram with html labels")

![ Hash table dot graph ](./graphviz-hash-table-graph.dot)

![ Constrained dot graph ](./graphviz-constrained-graph.dot)

![ Binary search tree dot graph ](./graphviz-binary-search-tree-graph.dot)

![ Process diagram with clusters ](./graphviz-process-cluster-graph.dot)

![ Call graph ](./graphviz-call-graph.dot)

![ Graph with edges on clusters ](./graphviz-edge-cluster-graph.dot)


***

- [ Back to ReadMe ](/ReadMe)


