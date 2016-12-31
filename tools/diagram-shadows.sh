#!/bin/bash

set -- "example/graphviz-binary-search-tree-graph"

DOT=dot
CONVERT=convert

# XXX: Downside of -GNE is that is overrides any in-graph attribute
$DOT -Tpng -Nstyle=filled -Nfillcolor=white -Gbgcolor=transparent $1.dot.gv > all.png
$DOT -Tpng -Nstyle=filled -Nfillcolor=white -Estyle=invis -Gbgcolor=transparent  $1.dot.gv > no_edges.png
$CONVERT all.png \( no_edges.png -background black -shadow 50x3+0+5 \) +swap -background none -layers merge +repage $1.png
#rm -f all.png no_edges.png
echo  $1.png
realpath all.png
realpath $1.png

