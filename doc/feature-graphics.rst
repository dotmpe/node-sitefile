:created: 2017-03-11
:updated: 2017-08-25


.. include:: .defaults.rst

This is a generic feature document to serve as overview to all graphics related
features.


Graphviz
  Use any of the Graphviz programs to render digraphs described in ASCII to
  various formats, notably PNG, SVG and PostScript.

  .. pull-quote::

    Graphviz was initiated by "AT&T Labs Research", its first version appeared
    over 25 years ago. The project consists of a source syntax (called 'DOT')
    for network graphs, and a handful of graph layout engines have been used
    directly or indirectly by numerous projects. [WP]


PlantUML
  Use the PlantUML distributable to compute PNG, SVG, LaTeX or ASCII diagrams
  given Graphviz-like source extended for common UML graphing tasks.

  .. pull-quote::

    PlantUML is a UML graph syntax and layout engine in Java, similar to Graphviz
    but extending the syntax to serve some common UML graphing needs.

    Initially PlantUML (from 2009 [WP]) was based on GraphViz, but it has since
    provided for its own layout engine. Besides UML it has subprojects for UI
    design, GANTT charts, and also supports the Ditaa format and has Math display.


Image compositing
  ..

    TODO: Bitmap processing can be done with Imagemagick compositing -- like
    PlantUML can do built-in drop-shadows for any transparent PNG by running
    some compositing.

    See http:/tools/diagram-shadows.sh.

  Use case: dot-diagram shadows
    Background: Requires two graphviz renders and an ImageMagick CLI recipe.
    Going to have convert.filter router take local options for route.
    Need to use path with params, see if glob still kicks in.


Compound Graphs
  ..

    XXX: graphing at an abstract, generic level has requirements quite similar
    to HTML. In fact one may regard graphic arrangement as the visual antipode
    of text authoring, or typesetting. Each has its own modes. And in addition
    to their natural properties, their electronic counterparts share a common
    affordance like those described by Ted Nelson: dynamic branching; on-request
    behaviours and novel modes that extend or surpass the conventional forms.

    At this axis, we might even suppose outlining lies exactly in between text
    and graph authoring. (Some musings on outliners are in the `Text Feature`
    document.)

    Hypertext is a given nowadays. Jet graphics are by nature more opaque, and
    often only appear as a structure with a minimum of semantics, a bitmap. This
    task would focus enabeling on a formalized description for graphics or at
    least graphs.

    There is `an excellent writeup`__ on the problem of modelling complex
    networked **and** *nested* diagrams with conventional tools in an answer on
    StackOverflow. The conventional tool is UML, and well-defined by omg.org.

    In terms of a concrete targets, focus would be on:

    - parse, author graph definitions; either or both DOT or omg.org XML based.

    - navigate, hyper-link to/from elements. Integrate with the same dynamic
      branching functions as regular text oriented documents.


.. __: https://stackoverflow.com/questions/37958198/how-to-represent-a-compound-graph-using-uml-notations-diagrams



Appendix
========

Changelog
---------
2017-03-11
  started as overview for a graphics related features.
2017-08-25
  - cleaned it up, to prepare for more generic diagramming feature requirements.
  - added initial thoughts on further directions with aim to get at a
    dynamically branching graph mode for documents. Graph/UML/SysML/...

