#!/bin/bash
read -s -p 'github password:' githubpw
echo
read -s -p 'coding password:' codingpw
echo

bundle exec jekyll build --destination ./docs
cp ./CNAME ./docs/
touch ./docs/.nojekyll
git add -A;git commit -m "$*";
cd docs
git add -A;git commit -m "$*";
cd ..

./push_expect.sh $githubpw $codingpw