
test -n "$1" || set -- origin

# List features

echo "Listing features for remote $1" 1>&2

git show-ref | grep refs.remotes.$1.features | cut -d' ' -f2 \
  | xargs basename | while read feature
do

  grep -q "^\s*$feature\s*$" doc/scm-branches.rst && {
    echo "Branch doc: '$feature' OK" 1>&2
  } || {
    echo "Branch doc does not mention '$feature'!" 1>&2
  }

done

# TODO: include in checks

