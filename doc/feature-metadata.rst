
Deal with basic (file based) stores for metadata.
Beginning with YAML and JSON, which conveniently are structurally very close.

But not quite. Using Ajv for JSON schema validation.
TODO: check wether scalar datatypes can be entered, tested.


JSON Reference and Pointers
  There are 2012 draft IETF RFC's for referencing data in JSON objects.
  Either to re-use pieces internally, or to include external pieces.

  The value of a '$ref' key must be a URL, or only URL fragment for a local
  in-file reference.

  - https://tools.ietf.org/html/draft-pbryan-zyp-json-ref-03
  - https://tools.ietf.org/html/draft-ietf-appsawg-json-pointer-04

JSON Path
  Alternatively, for more complex queries a port of XPath technology is
  available in NPM.

  - http://goessner.net/articles/JsonPath/
  - https://www.npmjs.com/package/JSONPath

jq, objectpath
  ``jq`` is a command line tool for JSON data queries.
  It has its own variant on path-like, attribute access syntax::

    .foo.bar
    .[<string>]
    .[2]
    .[10:15]

  A library with similar goals is ``ObjectPath``::

    $..*[@..temp > 25 and @.clouds.all is 0].name


