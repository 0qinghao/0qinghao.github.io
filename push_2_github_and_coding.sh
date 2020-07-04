#!/bin/bash
bundle exec jekyll build --destination ./docs

touch docs/baidu_sitemap.xml
# sed -e 's/0qinghao.github.io\/inforest/7u7d9c.coding-pages.com/' docs/sitemap.xml> docs/baidu_sitemap.xml

git add -A;git commit -m "$*";git push;

cd docs
git add -A;git commit -m "$*";git push coding master;