#!/bin/bash
bundle exec jekyll build --destination ./docs

<<<<<<< HEAD
# touch docs/baidu_sitemap.xml
=======
touch docs/baidu_sitemap.xml
>>>>>>> 1976014956ebdc4801b2ea70e5aefbdadb836cee
# sed -e 's/0qinghao.github.io\/inforest/7u7d9c.coding-pages.com/' docs/sitemap.xml> docs/baidu_sitemap.xml

git add -A;git commit -m "$*";git push;

cd docs
git add -A;git commit -m "$*";git push coding master;