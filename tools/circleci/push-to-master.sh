#!/bin/sh

# This script pushes the contents of `./stage/_book` directory to
# `origin/master` branch.
#
# Requirements:
# - CI must be configured with write access to the git remote `origin`.
# - The current directory must be the top directory of the CircleCI
#   project.
# - The current git branch must be `master` branch. (See circle.yml's
#   deployment -> branch)

set -e

if [ "x_$CIRCLE_BRANCH" != "x_master" ]; then
  echo "This commit was made against the $CIRCLE_BRANCH and not the master. Aborting."
  exit 4
fi

# Get the revision of this branch (master branch)
REVISION=$(git rev-parse --short HEAD)

mkdir -p ./docs/rust-by-example
cp -rp ./stage/_book/* ./docs/rust-by-example

(cd ./docs; \
 # Dirty hack to enable syntax highlight in local \
 sed -i -e 's!/gitbook/plugins/gitbook-plugin-rust-playpen/mode-rust.js!/rust-by-example/gitbook/plugins/gitbook-plugin-rust-playpen/mode-rust.js!' ./rust-by-example/gitbook/plugins/gitbook-plugin-rust-playpen/editor.js)

cp -rp ./gitbook/* ./docs/rust-by-example/gitbook/

# If there are anything to commit, do `git commit` and `git push`
# -f flag is needed as docs is listed in .gitignore
git add -f docs
set +e
ret=$(git status | grep -q 'nothing to commit'; echo $?)
set -e
if [ $ret -eq 0 ] ; then
    echo "Nothing to push to master."
else
    git commit -m "ci: generate pages at ${REVISION} [ci skip]"
    echo "Pushing to master."
    git push origin master
fi