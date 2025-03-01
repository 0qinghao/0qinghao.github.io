#!/bin/bash
# bundle exec jekyll build --destination ./docs
cp ./baidu* ./docs
cp ./google* ./docs
touch ./docs/.nojekyll

git add -A
git commit -m "$*"
git push origin master
