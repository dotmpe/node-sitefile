
# GIT Merge --theirs.

# Useful after embedded version strings or other branch-specific
# boilerplate has been regenerated.

# However, the branch must be fully merged up to the version update
# Don't use it to merge with anythign other than such a commit or it'll
# revert local changes ofcourse!
# In out-of-sync branches, merge up to before the version-update,
# use this script merge with the version update, regenerting the versions for
# this branch and committing. After that any merge with the target branch
# should simply fast-forward.

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
#git merge $2
git co $2
git merge ${1}_${2}_upstream
git branch -D ${1}_${2}_upstream
git-versioning check
#git-versioning testing $2
sed -i.bak 's/-'$(echo $1|tr '_' '-')'/-'$(echo $2|tr '_' '-')'/' ReadMe.rst package.yaml Sitefile.yaml
git-versioning update
git-versioning check
git add -u
rm *.bak
#

# Id: node-sitefile/0.0.4-master+20161010 tools/merge-upstream.sh

