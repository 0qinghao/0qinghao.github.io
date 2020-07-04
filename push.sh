#!/bin/bash
bundle exec jekyll build --destination ./docs
cp ./CNAME ./docs/

# touch docs/baidu_sitemap.xml
# sed -e 's/0qinghao.github.io\/inforest/7u7d9c.coding-pages.com/' docs/sitemap.xml> docs/baidu_sitemap.xml

git add -A;git commit -m "$*";git push origin master;

cd docs
touch .nojekyll
git add -A;git commit -m "$*";git push coding master;
git add -A;git commit -m "$*";git push githubpage master;