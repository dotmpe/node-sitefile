

gv
  Graphviz suite has dot, neato, twopi and other graph diagram layout engines.

plantuml
  Misc. classes of UML diagrams.

  Would want to hyperlink on images, but for me SVG is working for now.

rr-dia
  TODO Rail-road syntax diagrams to illustrate EBNF, ABNF?

  - http://xahlee.info/parser/bnf_ebnf_abnf.html

  EBNF - Extended Backus-Nauer Form
    ============================== =====================
    Usage                          Notation
    ------------------------------ ---------------------
    definition                     ``=``
    concatenation                  ``,``
    termination                    ``;``
    alternation                    ``|``
    option                         ``[ ... ]``
    repetition                     ``{ ... }``
    grouping                       ``( ... )``
    terminal string                ``" ... "``
    terminal string                ``' ... '``
    comment                        ``(* ... *)``
    special sequence               ``? ... ?``
    exception                      ``-``
    ------------------------------ ---------------------
    repetition-symbol              ``*``
    except-symbol                  ``-``
    concatenate-symbol             ``,``
    definition-symbol-separator    ``|``
    defining-symbol                ``=``
    terminator-symbol              ``;``
    ============================== =====================

  ABNF - Augmented Backus-Nauer Form
    ===================== ============== =============== ===========================================================
    Category              Notations      Example         Notes
    --------------------- -------------- --------------- -----------------------------------------------------------
    Rule                  ``= =/``       ``S = A``       ``=/`` is usually used to extend an already-defined rule
    Alternation           ``/``          ``A / B``       Despite the use of ``/``, this is unordered choice
    Concatenation         whitespace     ``A B``
    Grouping              ``()``         ``(A / B) C``
    Bounded Repetition    ``*``          ``3*5 A``       In ABNF, repetition precedes the element
    Optional              ``*1``         ``*1 A``
    One or more           ``1*``         ``1* A```
    Zero or more          ``*``          ``*A``
    String terminal       ``"" ''``      ``'a' "a"``     Single-quoted strings are an instaparse extension
    Regex terminal        ``#"" #''``    ``#'a' #"a"``   Regexes are an instaparse extension
    Character terminal    ``%d %b %x``   ``%x30-37``
    Comment               ``;``          ``;``           comment to the end of the line
    Lookahead             ``&``          ``&A``          Lookahead is an instaparse extension
    Negative lookahead    ``!``          ``!A``          Negative lookahead is an instaparse extension
    ===================== ============== =============== ===========================================================



TODO: HTML image map support for Graphviz, PlantUML.
  http://stackoverflow.com/questions/7844399/responsive-image-map
  Would need (jQuery) plugin to scale the coordinates for responsive layouts.


