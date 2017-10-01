"""
Builder for node-sitefile.readthedocs.io
"""
from recommonmark.parser import CommonMarkParser

source_parsers = {
  '.md': CommonMarkParser,
}

source_suffix = ['.rst', '.md']
