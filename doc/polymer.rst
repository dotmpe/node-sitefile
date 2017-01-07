Getting started with Polymer
============================

- The webscape is a bit convoluted. Lots of projects around polymer pop up on
  NPM, or Bower. Polymer has a bit of a learning curve.

- The preferred (or official) way to deal with Polymer looks to be Bower,
  so re-adding that on the features/polymer branch and see how that goes.


Getting started::

  bower install --save Polymer/polymer#^0.5

Start writing a custom element to see what polymer is about.
See the Jade template and HTML result at `example </example/polymer-custom>`_.

Getting more prefab core elements::

  bower install --save Polymer/core-toolbar

Bower will install other prefab elements along: core-icon, etc.

And that's it! See `another polymer example </example/polymer-example>`_
for the result of the single page app scaffolding using Polymer/core-drawer-panel.
This is all mentioned in the polymer docs, and should be enough to handle the
rest. https://www.polymer-project.org

----

Intro
------
Using Polymer is one way to step up from the old HTML hypertext document
semantics to new customized 'document schemas', adapted to specific domains and
methodologies but build from re-usable components.

HTML5 presents a new freedom in scaffolding hypertext, so that attention can get
back to the core of website design: disclosing and representing multimedia content.
One further topic regarding custom elements databinding, and Polymer's ideas of
Model Driven Views.

To step back again, consider some other topics of `modern web scripting <http://superherojs.com>`_.

----

With Polymer, the 'vulcanized' file has all element imports merged somehow.
A way to organize the element imports is put all the links in a separate file
and import that. One step up from that is appearantly to 'vulcanize' them.


----

Maybe polymer can be got to work in sf-v0.
But using HTML links. Not inline script?

----

.. raw:: markdown

  Polymer is based on a set of future technologies, including [Shadow
  DOM](http://w3c.github.io/webcomponents/spec/shadow/), [Custom
  Elements](http://w3c.github.io/webcomponents/spec/custom/) and Model Driven
  Views. Currently these technologies are implemented as polyfills or shims, but
  as browsers adopt these features natively, the platform code that drives Polymer
  evacipates, leaving only the value-adds.

