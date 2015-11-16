
# GIT Merge --theirs.
# Useful after embedded version strings or other branch-specific
# boilerplate has been regenerated.

set -xe

current_branch()
{
  git status | head -n 1 | sed 's/On branch //'
}

test -n "$1" || set "master" "$2"
test -n "$2" || set "$1" "$(current_branch)"

test "$1" != "$2" || {
  echo "Same branches $1 $2"
  exit 1
}

git co $1
git co -b ${1}_${2}_upstream
git merge --strategy=ours $2
git co $2
git merge ${1}_${2}_upstream
git branch -D ${1}_${2}_upstream
git-versioning check
#git-versioning testing $2
sed -i.bak 's/-master/-demo/' ReadMe.rst package.yaml Sitefile.yaml
git-versioning update
git-versioning check
git add -u
#

# Id: node-sitefile/0.0.4-master tools/merge-upstream.sh

