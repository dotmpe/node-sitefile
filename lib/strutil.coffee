chalk = require 'chalk'


# Common scans
String::startsWith ?= (s) -> @[...s.length] is s
String::endsWith   ?= (s) -> s is '' or @[-s.length..] is s


# Ansi colors
c =
  sc: chalk.grey ':' # sc: separator-char


module.exports =
  c: c


