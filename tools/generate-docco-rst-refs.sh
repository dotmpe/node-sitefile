#!/bin/sh

test -n "$out_fmt" || out_fmt=rst
test -n "$base_url" || base_url=/doc/literate/

find build/docs/docco -type f -print0 |
  xargs -0 basename |
  grep '\.html$' | {

  case "$out_fmt" in

    rst )
        while read htmlname
        do
          printf -- ".. _%s: %s$htmlname\n" "$(basename $htmlname .html)" "$base_url"
        done
      ;;

    * ) echo "? out-fmt: '$out_fmt'" >&2 ; exit 1
      ;;
  esac
}
