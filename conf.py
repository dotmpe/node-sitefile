"""
Sphinx config - Builder for node-sitefile.readthedocs.io
"""
from recommonmark.parser import CommonMarkParser

source_parsers = {
  '.md': CommonMarkParser,
}

source_suffix = ['.rst', '.md']

#rst_link_suffix = '.rst'

keep_warnings = True

intersphinx_mapping = {
    'python': ('http://python.readthedocs.io/en/latest/', None),
    'django': ('http://django.readthedocs.io/en/1.8.x/', None),
    'sphinx': ('http://sphinx.readthedocs.io/en/latest/', None),
}
