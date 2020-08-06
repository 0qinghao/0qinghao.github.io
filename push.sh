#!/bin/bash
bundle exec jekyll build --destination ../0qinghao.github.io
# jekyll build --destination ./docs
cp ./CNAME ../0qinghao.github.io
touch ../0qinghao.github.io/.nojekyll

read -s -p 'github password:' githubpw
echo
read -s -p 'coding password:' codingpw
echo

git add -A;git commit -m "$*";
cd ../0qinghao.github.io
git add -A;git commit -m "$*";
cd ../jekyll.0qinghao.github.io

./push_expect.sh $githubpw $codingpw