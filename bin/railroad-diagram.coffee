
libsf = require '../lib/sitefile'


ctx = libsf.new_context {}


rrdr = require('../lib/sitefile/routers/rr-dia') ctx


rrdr.lib.eval_rr

rds = require 'railroad-diagrams'
console.log rds
{
  Terminal, NonTerminal, Comment, Skip,
  Sequence, Choice, Optional, OneOrMore, ZeroOrMore

} = rds




