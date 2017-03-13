#!/bin/sh

set -e



# Set env for str.lib.sh
str_load()
{
  noop
}


str_upper()
{
  test -n "$1" \
    && { echo "$1" | tr 'a-z' 'A-Z'; } \
    || { cat - | tr 'a-z' 'A-Z'; }
}

str_lower()
{
  test -n "$1" \
    && { echo "$1" | tr 'A-Z' 'a-z'; } \
    || { cat - | tr 'A-Z' 'a-z'; }
}


# Use this to easily matching strings based on glob pettern, without
# adding a Bash dependency (keep it vanilla Bourne-style shell).
fnmatch()
{
  case "$2" in $1 ) return 0 ;; *) return 1 ;; esac
}

words_to_lines()
{
  test -n "$1" && {
    while test -n "$1"
    do echo "$1"; shift; done
  } || {
    tr ' ' '\n'
  }
}
lines_to_words()
{
  test -n "$1" && {
    { while test -n "$1"
      do cat "$1"; shift; done
    } | tr '\n' ' '
  } || {
    tr '\n' ' '
  }
}
words_to_unique_lines()
{
  words_to_lines | sort -u
}
unique_words()
{
  words_to_unique_lines | lines_to_words
}
reverse_lines()
{
  sed '1!G;h;$!d'
}

# Id: node-sitefile/0.0.6-dev tools/str.lib.sh
