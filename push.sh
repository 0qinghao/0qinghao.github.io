#!/bin/bash
# bundle exec jekyll build --destination ./docs
jekyll build --destination ./docs
cp ./CNAME ./docs/
touch ./docs/.nojekyll

read -s -p 'github password:' githubpw
echo
read -s -p 'coding password:' codingpw
echo

git add -A;git commit -m "$*";
cd docs
git add -A;git commit -m "$*";
cd ..

./push_expect.sh $githubpw $codingpw