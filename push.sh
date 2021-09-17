#!/bin/bash
bundle exec jekyll build --destination ../0qinghao.github.io
# jekyll build --destination ./docs
cp ./CNAME ../0qinghao.github.io
touch ../0qinghao.github.io/.nojekyll

git add -A
git commit -m "$*"
cd ../0qinghao.github.io
git add -A
git commit -m "$*"

cd ../jekyll.0qinghao.github.io
git push origin master
cd ../0qinghao.github.io
git push origin master
